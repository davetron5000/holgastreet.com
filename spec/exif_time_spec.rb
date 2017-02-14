require "spec_helper"
require_relative "../src/exif_time"

RSpec.describe ExifTime do
  describe "::parse" do
    it "returns a date based on exif's weirdo format" do
      exif_string = "2016:03:12 12:34:12"
      expect(ExifTime.parse(exif_string)).to eq(Date.parse("2016-03-12"))
    end
  end
end
