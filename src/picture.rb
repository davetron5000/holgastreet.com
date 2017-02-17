require "immutable-struct"
require_relative "thumbnail"
require_relative "lat_long"
require_relative "lat_long_coordinate"
require_relative "exif_time"

Picture = ImmutableStruct.new(:file, :iso, :film_type, :description, :lat, :long, :taken_on) do
  def self.in_file_from_exif_data(file:, exif_data: )
    self.new(
      file: file,
      iso: exif_data["ISO"],
      film_type: exif_data["Make"],
      description: exif_data["Description"],
      lat: LatLongCoordinate.from_exif(exif_data["GPSLatitude"]),
      long: LatLongCoordinate.from_exif(exif_data["GPSLongitude"]),
      taken_on: ExifTime.parse(exif_data["CreateDate"])
    )
  end

  def taken_on_pretty
    taken_on.strftime("%B %e, %Y")
  end

  def coordinate
    if lat.nil? || long.nil?
      nil
    else
      LatLong.new(lat: lat.to_f, long: long.to_f)
    end
  end

  def slug
    "%{date}/%{basename}" % {
      date: taken_on.strftime("%Y-%m-%d"),
      basename: file.basename(file.extname).to_s
    }
  end

  def thumb_url
    thumbnail.url
  end

  def url
    file.basename
  end

  def thumbnail
    @thumbnail ||= Thumbnail.new(self)
  end
end

