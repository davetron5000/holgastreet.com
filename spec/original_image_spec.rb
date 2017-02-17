require "spec_helper"
require_relative "../src/original_image"

RSpec.describe OriginalImage do
  describe "#roll_name" do
    let(:test_picture_path) {
      here = File.join(Dir.pwd,"spec","images")
      File.join(here,"test.jpg")
    }
    context "when there is a roll name" do
      before do
        unless system("exiftool -Keywords=\"roll:2014-01-02\" -Keywords=foo -Keywords=bar #{test_picture_path} >/dev/null")
          raise "Problem setting keywords"
        end
      end

      it "uses the keyword with the roll: prefix" do
        original_image = OriginalImage.new(test_picture_path)
        expect(original_image.roll_name).to eq("2014-01-02")
      end
    end
    context "when there is no roll name" do
      before do
        unless system("exiftool -Keywords=foo -Keywords=bar #{test_picture_path} >/dev/null")
          raise "Problem setting keywords"
        end
      end

      it "returns nil" do
        original_image = OriginalImage.new(test_picture_path)
        expect(original_image.roll_name).to be_nil
      end

      it "returns nil a default if asked" do
        original_image = OriginalImage.new(test_picture_path)
        expect(original_image.roll_name(default: "foo")).to eq("foo")
      end
    end
  end
end
