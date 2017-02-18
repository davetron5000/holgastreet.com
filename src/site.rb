require 'pathname'
require 'fileutils'
require_relative "original_image"
require_relative "picture"
require_relative "roll"
require_relative "template_models"
require_relative "logging"
require_relative "image_detector"
require_relative "roll_directories_builder"

class Site
  include FileUtils
  include Logging

  def initialize
    @image_detector = ImageDetector.new(Pathname.new(Dir.pwd) / "original_images")
    @images_dir = Pathname.new(Dir.pwd) / "site" / "images" / "holgastreet"
    @roll_directories_builder = RollDirectoriesBuilder.new(@images_dir)
    @templates_dir = Pathname.new(Dir.pwd) / "templates"
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
    File.open("site/about.html","w") do |file|
      about_template = TemplateModels::About.new
      about_template.template_file = @templates_dir / "about.mustache"
      file.puts about_template.render
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
    info "Copying CSS"
    mkdir_p "site/css"
    cp "node_modules/tachyons/css/tachyons.min.css", "site/css"
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
