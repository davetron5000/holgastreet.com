require "immutable-struct"

require_relative "./sleeve"
require_relative "./roll_data_file"

Roll = ImmutableStruct.new(:name, [:pictures], :theme, :description, :roll_number, :draft?, :roll_image) do

  def self.from_pictures_and_data(name: , roll_number: , pictures:, data_file: )
    roll_data_file = RollDataFile.new(data_file)
    roll_data = roll_data_file.roll_data(name)
    roll_image = if roll_data["main_image"].nil?
                   pictures.first
                 else
                   pictures.detect { |_| _.file.basename.to_s == roll_data["main_image"] }.tap { |picture|
                     raise "No picture named #{roll_data['main_image']} in #{pictures.map(&:file).map(&:basename).join(',')}" if picture.nil?
                   }
                 end
    self.new(name: name.gsub(/[\+\&\?\s]/,''),
             pictures: pictures,
             roll_number: roll_number,
             theme: roll_data["theme"],
             description: roll_data["description"],
             draft: roll_data["draft"],
             roll_image: roll_image)
  end

  def pretty_name
    Date.parse(name).strftime("%B %e, %Y")
  rescue
    name
  end

  def roll_image_thumb_url
    roll_image.thumb_url
  end

  def sleeves
    pictures.sort_by(&:file).each_slice(3).map { |pictures|
      Sleeve.new(pictures: pictures)
    }
  end
end
