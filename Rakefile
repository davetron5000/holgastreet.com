$: << File.join(Dir.pwd,"src")
require 'site'
require 'rspec/core/rake_task'

task :site do
  Site.new.build!
end
RSpec::Core::RakeTask.new(:spec)

#image_dirs = Pathname.new("images/holgastreet")
#
#images_and_thumbs = image_dirs.each_child.select(&:directory?).map { |image_dir|
#  image_dir.each_child.reject(&:directory?).select { |image|
#    [".jpg",".jpeg"].include?(image.extname.downcase)
#  }.map { |image|
#    [image,image.parent / 'thumbs' / image.basename]
#  }
#}.flatten(1)
#
#images_and_thumbs.each do |full_size,thumb|
#  #desc "Make thumb for #{full_size}" # useful to debug this
#  file thumb => full_size do
#    mkdir_p thumb.parent
#    chdir full_size.parent do
#      command = "convert -format png #{full_size.basename} -thumbnail 600x600 thumbs/#{full_size.basename}"
#      sh command do |ok,res|
#        unless ok
#          fail "Couldn't execute '#{command}': #{res.inspect}"
#        end
#      end
#    end
#
#  end
#end
#
#desc "Create thumbnails"
#task :thumbs => images_and_thumbs.map {|_| _[1] }
#
#task :default => :thumbs do
#end
#
task :build do
  Dir["original_images/*.jpg"].each do |image_filename|
    stdout,_stderr,status = Open3.capture3("exiftool -json #{image_filename}")
    if status.success?
      json = JSON.parse(stdout)[0]

      picture = Picture.new(
               file: Pathname.new(File.join(Dir.pwd,json["SourceFile"])),
                iso: json["ISO"],
          film_type: json["Make"],
        description: json["ImageDescription"],
                lat: LatLong.from_exif(json["GPSLatitude"]),
               long: LatLong.from_exif(json["GPSLongitude"]),
           taken_on: ExifTime.parse(json["CreateDate"]))

      puts picture.url("/images")
    else
      raise _stderr
    end
  end
end

require 'mustache'

class Main < Mustache
  self.template_path = "templates"

  def contact_sheets
    Dir["images/holgastreet/*"].reject { |dir|
      dir =~/^\./
    }.map { |dir|
      ContactSheet.new(dir)
    }
  end

  class ContactSheet
    def initialize(dir)
      @files = (Dir[dir + "/*.jpg"] + Dir[dir + "/*.jpeg"]).map { |file|
        Photo.new(file)
      }
    end

    def pretty_date
      "Jan 1, 2012"
    end

    def sleeves
      @files.each_slice(3).map { |photos|
        Sleeve.new(photos)
      }
    end
  end
  class Sleeve
    attr_reader :photos
    def initialize(photos)
      @photos = photos
    end
  end

  class Photo
    def initialize(file)
      @file = Pathname.new(file)
    end

    def slug
      "foo"
    end

    def thumb_url
      @file.parent / 'thumbs' / @file.basename
    end

  end
end
task :build do
  mkdir_p "site"
  File.open("site/index.html","w") do |file|
    file.puts Main.render
  end
end
