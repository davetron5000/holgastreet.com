require "spec_helper"
require_relative "../src/roll_directories_builder"
require_relative "../src/original_image"

RSpec.describe RollDirectoriesBuilder do
  describe "#build_roll_directories" do
    it "creates directories for each unique roll in the OriginalImage list" do
      original_images = [
        instance_double(OriginalImage, roll_name: "foo"),
        instance_double(OriginalImage, roll_name: "bar"),
        instance_double(OriginalImage, roll_name: "foo"),
        instance_double(OriginalImage, roll_name: "bar"),
        instance_double(OriginalImage, roll_name: "quux"),
      ]

      Dir.mktmpdir do |dir|
        roll_directories_builder = RollDirectoriesBuilder.new(dir)
        roll_directories_builder.build_roll_directories(original_images)

        expect(Pathname("#{dir}/foo").exist?).to eq(true)
        expect(Pathname("#{dir}/bar").exist?).to eq(true)
        expect(Pathname("#{dir}/quux").exist?).to eq(true)
      end
    end
  end
end
