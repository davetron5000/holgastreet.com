require 'pathname'
require 'open3'
require 'json'

class OriginalImage
  attr_reader :path
  def initialize(path)
    @path = Pathname.new(path)
  end

  def picture(dest_dir)
    @picture ||= Picture.in_file_from_exif_data(file: dest_dir / roll_name / path.basename, exif_data: exif_data)
  end

  def roll_name(default: nil)
    @roll_name ||= begin
                       keywords = exif_data["Keywords"]
                       keywords = keywords.to_s.split(/,/) unless keywords.kind_of?(Array)
                       keywords.select { |keyword|
                         keyword =~ /^roll:/
                       }.map { |roll_keywords|
                         roll_keywords.split(/:/,2)[1]
                       }.first or default
                   end
  end

private

  def exif_data
    command = "exiftool -json #{@path}"
    stdout,stderr,status = Open3.capture3(command)
    if status.success?
      exif_data = JSON.parse(stdout).first
    else
      raise "Problem executing '#{command}':\n#{stderr}"
    end
  end
end
