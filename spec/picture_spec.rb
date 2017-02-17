require "spec_helper"
require "date"
require "pathname"
require "json"
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
      expect(picture.thumb_url("/images").to_s).to eq("/images/thumbs/blah.jpg")
    end
  end
  describe "#url" do
    it "returns the URL to file, based on the filename" do
      picture = Picture.new(file: Pathname.new("foo/bar/blah.jpg"))
      expect(picture.url("/images").to_s).to eq("/images/blah.jpg")
    end
  end

  describe "::in_file_from_exif_data" do
    let(:exif_data) {
      string = %{{
  "SourceFile": "Washington - NoMA - District of Columbia, February 9, 2017/UnionKitchenGrocery2.jpg",
  "ExifToolVersion": 10.40,
  "FileName": "UnionKitchenGrocery2.jpg",
  "Directory": "Washington - NoMA - District of Columbia, February 9, 2017",
  "FileSize": "1317 kB",
  "FileModifyDate": "2017:02:16 18:38:21-05:00",
  "FileAccessDate": "2017:02:16 18:38:36-05:00",
  "FileInodeChangeDate": "2017:02:16 18:38:21-05:00",
  "FilePermissions": "rw-r--r--",
  "FileType": "JPEG",
  "FileTypeExtension": "jpg",
  "MIMEType": "image/jpeg",
  "JFIFVersion": 1.01,
  "ExifByteOrder": "Big-endian (Motorola, MM)",
  "ImageDescription": "I love coming to this place to see what they have and what inspires me.",
  "Make": "Kodak T-Max 400",
  "Model": "Holga 120N",
  "XResolution": 72,
  "YResolution": 72,
  "ResolutionUnit": "inches",
  "Software": "Photos 2.0",
  "ModifyDate": "2017:02:09 09:00:00",
  "ISO": 400,
  "DateTimeOriginal": "2017:02:09 09:00:00",
  "CreateDate": "2017:02:09 09:00:00",
  "ColorSpace": "sRGB",
  "ExifImageWidth": 3218,
  "ExifImageHeight": 3414,
  "GPSVersionID": "2.3.0.0",
  "GPSLatitudeRef": "North",
  "GPSLongitudeRef": "West",
  "GPSAltitude": "0 m",
  "XMPToolkit": "XMP Core 5.4.0",
  "CreatorTool": "Photos 2.0",
  "Description": "I love coming to this place to see what they have and what inspires me.",
  "Subject": ["holga","Holgastreet","roll:2017-02-05"],
  "Title": "Union Kitchen Grocery",
  "CurrentIPTCDigest": "920b49fbd1ce3e6ee4afb348bc5d8969",
  "CodedCharacterSet": "UTF8",
  "ApplicationRecordVersion": 2,
  "DigitalCreationDate": "2017:02:09",
  "ObjectName": "Union Kitchen Grocery",
  "DigitalCreationTime": "09:00:00",
  "DateCreated": "2017:02:09",
  "Caption-Abstract": "I love coming to this place to see what they have and what inspires me.",
  "TimeCreated": "09:00:00",
  "Keywords": ["holga","Holgastreet","roll:2017-02-05"],
  "IPTCDigest": "920b49fbd1ce3e6ee4afb348bc5d8969",
  "ImageWidth": 3218,
  "ImageHeight": 3414,
  "EncodingProcess": "Baseline DCT, Huffman coding",
  "BitsPerSample": 8,
  "ColorComponents": 3,
  "YCbCrSubSampling": "YCbCr4:2:0 (2 2)",
  "DateTimeCreated": "2017:02:09 09:00:00",
  "DigitalCreationDateTime": "2017:02:09 09:00:00",
  "GPSLatitude": "38 deg 53' 49.88\\" N",
  "GPSLongitude": "77 deg 0' 8.24\\" W",
  "GPSPosition": "38 deg 53' 49.88\\" N, 77 deg 0' 8.24\\" W",
  "ImageSize": "3218x3414",
  "Megapixels": 11.0
}}
      JSON.parse(string)
    }

    it "extracts the right values from the exif" do
      file = Pathname.new("foo")
      picture = Picture.in_file_from_exif_data(file: file, exif_data: exif_data)
      expect(picture.file).to eq(file)
      expect(picture.iso).to eq(400)
      expect(picture.film_type).to eq("Kodak T-Max 400")
      expect(picture.description).to eq("I love coming to this place to see what they have and what inspires me.")
      expect(picture.taken_on).to eq(Date.parse("2017-02-09"))
      expect(picture.lat.to_f).to eq(38.89718888888889)
      expect(picture.long.to_f).to eq(-77.00228888888888)
    end
  end
end
