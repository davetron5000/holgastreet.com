require "fileutils"
require "open3"

class Thumbnail
  def initialize(picture)
    @picture = picture
  end

  def url(base_url)
    PictureUrl.new(base_url,"thumbs/#{@picture.file.basename}")
  end

  def generate!
    thumb_dir = @picture.file.parent / "thumbs"
    FileUtils.mkdir_p thumb_dir
    command = "convert -format jpg #{@picture.file} -thumbnail 600x600 #{@picture.file.parent}/thumbs/#{@picture.file.basename}"
    stdout,stderr,status = Open3.capture3(command)
    unless status.success?
      fail "Couldn't execute '#{command}': #{status.inspect}\n#{stderr}"
    end
  end
end
