class LatLong
  def self.from_exif(exif_coordinate)
    return nil if exif_coordinate.to_s.strip == ''
    parts = exif_coordinate.split(/\s+/)
    self.new(
      parts[0],
      parts[2].gsub(/\'$/,''),
      parts[3].gsub(/\"/,''),
      parts[4])
  end

  def initialize(degrees,minutes,seconds,direction)
    @degrees   = degrees.to_f
    @minutes   = minutes.to_f
    @seconds   = seconds.to_f
    @direction = direction.upcase
  end

  def to_f
    sign = if (@direction == "W") || (@direction = "S")
             -1
           else
             1
           end

    @degrees + (@minutes / 60) + (@seconds / 60 / 60)
  end
end

