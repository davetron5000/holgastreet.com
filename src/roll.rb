require "immutable-struct"

require_relative "./sleeve"
require_relative "./roll_data_file"

Roll = ImmutableStruct.new(:name, [:pictures], :theme, :description, :roll_number, :draft?) do

  def self.from_pictures_and_data(name: , roll_number: , pictures:, data_file: )
    roll_data_file = RollDataFile.new(data_file)
    roll_data = roll_data_file.roll_data(name)
    self.new(name: name.gsub(/[\+\&\?\s]/,''), pictures: pictures, roll_number: roll_number, theme: roll_data["theme"], description: roll_data["description"], draft: roll_data["draft"])
  end

  def pretty_name
    Date.parse(name).strftime("%B %e, %Y")
  rescue
    name
  end

  def roll_image_thumb_url
    pictures.first.thumb_url
  end

  def sleeves
    pictures.sort_by(&:file).each_slice(3).map { |pictures|
      Sleeve.new(pictures: pictures)
    }
  end
end
