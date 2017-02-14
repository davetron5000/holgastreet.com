class PictureUrl
  def initialize(base_url, file_pathname)
    @base_url = base_url
    @file_pathname = file_pathname
  end

  def to_s
    "%{base}/%{dir}/%{file}" % {
      base: @base_url,
      dir: @file_pathname.parent,
      file: @file_pathname.basename
    }
  end
  alias :to_str :to_s
end
