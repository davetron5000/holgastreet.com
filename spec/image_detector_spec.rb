require "spec_helper"
require "fileutils"
require_relative "../src/image_detector"

RSpec.describe ImageDetector do
  describe "#detect_images" do
    it "detects all jpeg and jpg images in the given dir, converting them to OriginalImage instances" do
      Dir.mktmpdir do |dir|
        FileUtils.touch "#{dir}/foo.jpg"
        FileUtils.touch "#{dir}/bar.jpg"
        FileUtils.touch "#{dir}/quux.jpeg"
        FileUtils.touch "#{dir}/crud.png"
        FileUtils.touch "#{dir}/foobar"

        image_detector = ImageDetector.new(dir)
        images = image_detector.detect_images

        expect(images.size).to eq(3)
        expect(images.map(&:path).map(&:to_s)).to include("#{dir}/foo.jpg")
        expect(images.map(&:path).map(&:to_s)).to include("#{dir}/bar.jpg")
        expect(images.map(&:path).map(&:to_s)).to include("#{dir}/quux.jpeg")

      end
    end
  end
end
