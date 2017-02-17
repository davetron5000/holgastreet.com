require "spec_helper"
require_relative "../src/thumbnail"
require_relative "../src/picture"

RSpec.describe Thumbnail do
  describe "#url" do
    it "inserts /thumbs/ into the picture's url" do
      picture = Picture.new(file: Pathname.new("foo/bar.jpg"))
      thumbnail = Thumbnail.new(picture)
      expect(thumbnail.url.to_s).to eq("thumbs/bar.jpg")
    end
  end

  describe "#generate!" do
    it "uses ImageMagick to generate a thumbnail" do
      here = File.join(Dir.pwd,"spec","images")
      FileUtils.rm_rf(File.join(here,"thumbs"))

      picture = Picture.new(file: Pathname.new(File.join(here,"test.jpg")))
      thumbnail = Thumbnail.new(picture)
      thumbnail.generate!

      expect(File.exist?(File.join(here,"thumbs","test.jpg"))).to eq(true)
    end
  end
end
