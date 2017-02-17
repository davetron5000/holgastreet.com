require "spec_helper"
require "date"
require_relative "../src/roll"
require_relative "../src/picture"

RSpec.describe Roll do
  describe "#pretty_name" do
    it "pretty-prints the date" do
      contact_sheet = Roll.new(name: "2017-01-03")
      expect(contact_sheet.pretty_name).to eq("January  3, 2017")
    end
    it "handles a non-date name" do
      contact_sheet = Roll.new(name: "foo")
      expect(contact_sheet.pretty_name).to eq("foo")
    end
  end

  describe "#sleeves" do
    it "returns one sleeve for each three pictures" do
      pictures = [
        Picture.new(file: Pathname.new("foo1.jpg")),
        Picture.new(file: Pathname.new("foo2.jpg")),
        Picture.new(file: Pathname.new("foo3.jpg")),
        Picture.new(file: Pathname.new("foo4.jpg")),
        Picture.new(file: Pathname.new("foo5.jpg")),
        Picture.new(file: Pathname.new("foo6.jpg")),
        Picture.new(file: Pathname.new("foo7.jpg")),
      ]
      sleeves = Roll.new(pictures: pictures).sleeves
      expect(sleeves.size).to eq(3)
      expect(sleeves[0].pictures.size).to eq(3)
      expect(sleeves[1].pictures.size).to eq(3)
      expect(sleeves[2].pictures.size).to eq(1)
    end

    it "sorts pictures by file name" do
      pictures = [
        Picture.new(file: Pathname.new("foo1.jpg")),
        Picture.new(file: Pathname.new("foo2.jpg")),
        Picture.new(file: Pathname.new("foo3.jpg")),
        Picture.new(file: Pathname.new("foo4.jpg")),
        Picture.new(file: Pathname.new("foo5.jpg")),
        Picture.new(file: Pathname.new("foo6.jpg")),
        Picture.new(file: Pathname.new("foo7.jpg")),
      ]

      sleeves = Roll.new(pictures: pictures.shuffle).sleeves

      expect(sleeves[0].pictures).to eq(pictures[0..2])
      expect(sleeves[1].pictures).to eq(pictures[3..5])
      expect(sleeves[2].pictures).to eq(pictures[6..-1])
    end
  end
end
