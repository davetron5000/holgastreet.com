require "spec_helper"
require_relative "../src/lat_long_coordinate"

RSpec.describe LatLongCoordinate do
  describe "::from_exif" do
    it "converts to degrees" do
      lat_long_coordinate = LatLongCoordinate.from_exif("38 deg 54' 0.13\" N")
      expect(lat_long_coordinate.to_f).to eq(38.900036111111106)
    end

    it "uses a negative for 'W'" do
      lat_long_coordinate = LatLongCoordinate.from_exif("38 deg 54' 0.13\" W")
      expect(lat_long_coordinate.to_f).to eq(-38.900036111111106)
    end
  end
end
