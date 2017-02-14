require "immutable-struct"
require_relative "picture_url"

Picture = ImmutableStruct.new(:file, :iso, :film_type, :description, :lat, :long, :taken_on) do
  def coordinate
    if lat.nil? || long.nil?
      nil
    else
      [lat.to_f,long.to_f]
    end
  end

  def slug
    "%{date}/%{basename}" % {
      date: taken_on.strftime("%Y-%m-%d"),
      basename: file.basename(file.extname).to_s
    }
  end

  def thumb_url(base_url)
    PictureUrl.new(base_url,file.parent / "thumbs" / file.basename)
  end

  def url(base_url)
    PictureUrl.new(base_url,file)
  end
end

