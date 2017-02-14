class PictureUrl
  def initialize(base_url, file_pathname)
    @base_url = base_url
    @file_pathname = file_pathname
  end

  def to_s
    "%{base}/%{file}" % {
      base: @base_url,
      file: @file_pathname.to_s
    }
  end
  alias :to_str :to_s
end
