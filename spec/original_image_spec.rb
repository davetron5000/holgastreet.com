require "spec_helper"
require_relative "../src/original_image"

RSpec.describe OriginalImage do
  let(:test_picture_path) {
    here = File.join(Dir.pwd,"spec","images")
    File.join(here,"test.jpg")
  }
  describe "#picture" do
    before do
      unless system("exiftool -Keywords=\"roll:2014-01-02\" -Keywords=foo -Keywords=bar #{test_picture_path} >/dev/null")
        raise "Problem setting keywords"
      end
    end
    it "creates a picture passing through the exif data" do
      picture = instance_double(Picture)
      allow(Picture).to receive(:in_file_from_exif_data).and_return(picture)

      original_image = OriginalImage.new(test_picture_path)
      result = original_image.picture("/foo")
      expect(Picture).to have_received(:in_file_from_exif_data).with(file: Pathname("/foo/2014-01-02/test.jpg"), exif_data: instance_of(Hash))

    end
    it "creates a picture fixing up url-unfriendly-chars, passing through the exif data" do
      picture = instance_double(Picture)
      allow(Picture).to receive(:in_file_from_exif_data).and_return(picture)

      allow(Open3).to receive(:capture3).and_return( ["[{ \"Keywords\": \"roll:2014-01-02\" }]","",OpenStruct.new(success?: true)])
      original_image = OriginalImage.new("test+pic.jpg")
      result = original_image.picture("/foo")
      expect(Picture).to have_received(:in_file_from_exif_data).with(file: Pathname("/foo/2014-01-02/testpic.jpg"), exif_data: instance_of(Hash))

    end
  end
  describe "#roll_name" do
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

      it "returns blows up" do
        original_image = OriginalImage.new(test_picture_path)
        expect {
          original_image.roll_name
        }.to raise_error(/No roll found in keywords: 'foo,bar'/i)
      end

      it "returns nil a default if asked" do
        original_image = OriginalImage.new(test_picture_path)
        expect(original_image.roll_name(default: "foo")).to eq("foo")
      end
    end
  end
end
