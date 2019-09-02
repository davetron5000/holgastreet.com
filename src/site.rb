require 'pathname'
require 'fileutils'
require_relative "original_image"
require_relative "picture"
require_relative "roll"
require_relative "template_models"
require_relative "logging"
require_relative "image_detector"
require_relative "roll_directories_builder"
require_relative "atom_feed"

class Site
  include FileUtils
  include Logging

  def initialize(rolls_filename = "rolls.json")
    @image_detector = ImageDetector.new(Pathname.new(Dir.pwd) / "original_images")
    @images_dir = Pathname.new(Dir.pwd) / "site" / "images" / "holgastreet"
    @roll_directories_builder = RollDirectoriesBuilder.new(@images_dir)
    @templates_dir = Pathname.new(Dir.pwd) / "templates"
    @roll_data_file = Pathname.new(Dir.pwd) / rolls_filename
  end

  def build!
    original_images = @image_detector.detect_images
    @roll_directories_builder.build_roll_directories(original_images)
    generate_site(original_images)
    deploy!
  end

private

  def generate_site(original_images)
    images_by_roll = original_images.group_by(&:roll_name).sort_by { |roll_name,_|
      roll_name
    }
    copy_images_and_generate_thumbs(images_by_roll)
    rolls = images_by_roll.each_with_index.map { |(roll_name,images_in_roll),index|
      Roll.from_pictures_and_data(
        name: roll_name,
        data_file: @roll_data_file,
        roll_number: index + 1,
        pictures: images_in_roll.map { |image|
          image.picture(@images_dir)
        }.sort_by { |picture|
          picture.slug
        }
      ).tap { |roll|
        warn("No roll data for #{roll.name}") if roll.theme.nil? || roll.description.nil?
      }
    }.reject { |roll|
      roll.draft?.tap { |draft|
        info "Skipping #{roll.name} as it's just a draft" if draft
      }
    }.sort_by(&:name).reverse
    mkdir_p "site"
    create_index(rolls)
    create_roll_pages(rolls)
    create_about
    create_photo_pages(rolls)
    copy_css
    copy_static_html
    make_atom_feed(rolls)
  end

  def create_index(rolls)
    info "Creating site/index.html"
    File.open("site/index.html","w") do |file|
      index_template = TemplateModels::Index.new(rolls)
      index_template.template_file = @templates_dir / "index.mustache"
      file.puts index_template.render
    end
  end

  def create_roll_pages(rolls)
    info "Creating roll pages"
    mkdir_p "site/rolls"
    File.open("site/rolls/index.html","w") do |file|
      roll_index_template = TemplateModels::RollIndex.new(rolls)
      roll_index_template.template_file = @templates_dir / "roll_index.mustache"
      file.puts roll_index_template.render
    end
    rolls.each do |roll|
      File.open("site/rolls/#{roll.name}.html","w") do |file|
        roll_template = TemplateModels::Roll.new(roll)
        roll_template.template_file = @templates_dir / "roll.mustache"
        file.puts roll_template.render
      end
    end
  end

  def create_about
    File.open("site/about.html","w") do |file|
      about_template = TemplateModels::About.new
      about_template.template_file = @templates_dir / "about.mustache"
      file.puts about_template.render
    end
  end

  def create_photo_pages(rolls)
    info "Creating photo pages"
    rolls.each do |roll|
      roll.pictures.each_with_index do |picture, index|
        next_picture_url = if index >= (roll.pictures.size - 1)
                             nil
                           else
                             "/photos/" + roll.pictures[index + 1].slug + ".html"
                           end
        previous_picture_url = if index == 0
                                 nil
                               else
                                 "/photos/" + roll.pictures[index - 1].slug + ".html"
                               end
        path = Pathname("site") / "photos" / (picture.slug + ".html")
        mkdir_p path.parent
        File.open(path,"w") do |file|
          template = TemplateModels::Photo.new(roll, picture, previous_picture_url, next_picture_url)
          template.template_file = @templates_dir / "photo.mustache"
          file.puts template.render
        end
      end
    end
  end

  def copy_css
    info "Copying CSS"
    mkdir_p "site/css"
    cp "node_modules/tachyons/css/tachyons.min.css", "site/css"
  end

  def copy_static_html
    info "Copying Static HTML"
    Dir["html/*"].each do |file|
      cp file,"site"
    end
  end

  def make_atom_feed(rolls)
    File.open("site/atom.xml","w") do |file|
      AtomFeed.new(rolls).write_feed(file)
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

end
