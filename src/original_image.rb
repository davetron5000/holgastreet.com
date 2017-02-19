require 'pathname'
require 'open3'
require 'json'
require_relative 'picture'

class OriginalImage
  attr_reader :path
  def initialize(path)
    @path = Pathname.new(path)
  end

  def picture(dest_dir)
    dest_dir = Pathname(dest_dir)
    file_dir = dest_dir / roll_name
    clean_file_name = path.basename.to_s.gsub(/[\+\/\\\?\&]/,'')
    @picture ||= Picture.in_file_from_exif_data(file: file_dir / clean_file_name, exif_data: exif_data)
  end

  def roll_name(default: :raise)
    default_proc = if default == :raise
                     ->(keywords) { raise "No roll found in keywords: '#{keywords.join(',')}'" }
                   else
                     ->(*) { default }
                   end
    @roll_name ||= begin
                       keywords = exif_data["Keywords"]
                       keywords = keywords.to_s.split(/,/) unless keywords.kind_of?(Array)
                       keywords.select { |keyword|
                         keyword =~ /^roll:/
                       }.map { |roll_keywords|
                         roll_keywords.split(/:/,2)[1]
                       }.first or default_proc.(keywords)
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
