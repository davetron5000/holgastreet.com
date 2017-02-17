require 'pathname'
require 'fileutils'
require_relative "original_image"
require_relative "picture"
require_relative "roll"
require_relative "template_models"

class Site
  include FileUtils

  def initialize
    @original_image_dir = Pathname.new(Dir.pwd) / "original_images"
    @images_dir = Pathname.new(Dir.pwd) / "site" / "images" / "holgastreet"
    @templates_dir = Pathname.new(Dir.pwd) / "templates"
  end

  def build!
    images = detect_images
    mk_roll_dirs(images.map(&:roll_name).uniq)
    generate_site(images)
    deploy!
  end

private

  def detect_images
    info "Detecting images..."
    Dir[@original_image_dir / "*"].select { |file|
      file =~ /\.jpg$/i || file =~ /.jpeg$/i
    }.map  { |file|
      debug "Detected #{file}"
      OriginalImage.new(file)
    }
  end

  def mk_roll_dirs(roll_dirs)
    roll_dirs.map { |dir|
      @images_dir / dir
    }.each do |dir|
      info "Creating roll dir #{dir}"
      mkdir_p(dir)
    end
  end

  def generate_site(original_images)
    images_by_roll = original_images.group_by(&:roll_name).sort_by { |roll_name,_|
      roll_name
    }.reverse
    copy_images_and_generate_thumbs(images_by_roll)
    rolls = images_by_roll.map { |roll_name,images_in_roll|
      Roll.new(name: roll_name,
               pictures: images_in_roll.map { |image| image.picture(@images_dir) })
    }
    info "Creating site/index.html"
    mkdir_p "site"
    File.open("site/index.html","w") do |file|
      index_template = TemplateModels::Index.new(rolls)
      index_template.template_file = @templates_dir / "index.mustache"
      file.puts index_template.render
    end
    info "Creating photo pages"
    rolls.each do |roll|
      roll.pictures.each do |picture|
        path = Pathname("site") / "photos" / (picture.slug + ".html")
        mkdir_p path.parent
        File.open(path,"w") do |file|
          template = TemplateModels::Photo.new(roll,picture)
          template.template_file = @templates_dir / "photo.mustache"
          file.puts template.render
        end
      end
    end
  end

  def copy_images_and_generate_thumbs(images_by_roll)
    images_by_roll.each do |roll_name,images_in_roll|
      info "Setting up roll #{roll_name}"
      images_in_roll.each do |original_image|
        copy_to_path_and_generate_thumb(original_image,original_image.picture(@images_dir).file)
      end
    end
  end

  def copy_to_path_and_generate_thumb(original_image,dest_file)
    if dest_file.exist? && dest_file.mtime >= original_image.path.mtime
      cool "#{dest_file} is up to date"
    else
      info "#{dest_file} out of date"
      cp original_image.path, dest_file
      original_image.picture(@images_dir).thumbnail.generate!
    end
  end

  def deploy!
  end

  def info(message)
    puts "🔵  #{message}"
  end

  def debug(message)
    #puts "🐛  #{message}"
  end

  def cool(message)
    #puts "✅  #{message}"
  end
end
