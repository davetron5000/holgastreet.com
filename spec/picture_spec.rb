require "spec_helper"
require "date"
require "pathname"
require_relative "../src/picture"

RSpec.describe Picture do
  describe "#coordinate" do
    it "returns a 2-elemenet typle" do
      picture = Picture.new(lat: 12.3, long: 4.5)
      expect(picture.coordinate).to eq([12.3,4.5])
    end
    it "returns nil if lat is nil" do
      picture = Picture.new(long: 4.5)
      expect(picture.coordinate).to be_nil
    end
    it "returns nil if long is nil" do
      picture = Picture.new(lat: 4.5)
      expect(picture.coordinate).to be_nil
    end
  end

  describe "#slug" do
    it "returns a slug using the date and filename" do
      picture = Picture.new(taken_on: Date.parse("2016-03-02"), file: Pathname.new("foo.jpg"))
      expect(picture.slug).to eq("2016-03-02/foo")
    end
  end

  describe "#thumb_url" do
    it "returns the URL to the thumb, based on the filename" do
      picture = Picture.new(file: Pathname.new("foo/bar/blah.jpg"))
      expect(picture.thumb_url("/images").to_s).to eq("/images/foo/bar/thumbs/blah.jpg")
    end
  end
  describe "#url" do
    it "returns the URL to file, based on the filename" do
      picture = Picture.new(file: Pathname.new("foo/bar/blah.jpg"))
      expect(picture.url("/images").to_s).to eq("/images/foo/bar/blah.jpg")
    end
  end
end
