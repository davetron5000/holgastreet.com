require "spec_helper"
require "date"
require_relative "../src/roll"
require_relative "../src/picture"

RSpec.describe Roll do
  describe "::from_pictures_and_data" do
    it "reads the JSON file to fill in the theme and description of the rolls detected" do
      roll_name = "2013-03-01"
      Dir.mktmpdir do |dir|
        File.open("#{dir}/rolls.json","w") do |file|
          file.puts({
            "rolls" => [
              {
                "name": roll_name,
                "theme": "cats",
                "draft": true,
                "description": "The cats of the atlas district! #catlasdistrict :)",
              },
            ]
          }.to_json)
        end

        pictures = [ instance_double(Picture) ]
        roll = Roll.from_pictures_and_data(name: roll_name, pictures: pictures, data_file: dir + "/rolls.json", roll_number: 1)

        expect(roll.name).to eq(roll_name)
        expect(roll.pictures).to eq(pictures)
        expect(roll.draft?).to eq(true)
        expect(roll.theme).to eq("cats")
        expect(roll.roll_number).to eq(1)
        expect(roll.description).to eq("The cats of the atlas district! #catlasdistrict :)")
      end
    end
    it "uses nil if the roll name isn't in the JSON file" do
      Dir.mktmpdir do |dir|
        File.open("#{dir}/rolls.json","w") do |file|
          file.puts({
            "rolls" => [
              {
                "name": "foobar",
                "theme": "cats",
                "description": "The cats of the atlas district! #catlasdistrict :)",
              },
            ]
          }.to_json)
        end

        roll_name = "2013-03-01"
        pictures = [ instance_double(Picture) ]
        roll = Roll.from_pictures_and_data(name: roll_name, pictures: pictures, data_file: dir + "/rolls.json", roll_number: 1)

        expect(roll.name).to eq(roll_name)
        expect(roll.pictures).to eq(pictures)
        expect(roll.theme).to be_nil
        expect(roll.roll_number).to eq(1)
        expect(roll.description).to be_nil
      end
    end
  end
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
