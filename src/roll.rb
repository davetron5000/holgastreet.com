require "immutable-struct"
require_relative "./sleeve"

Roll = ImmutableStruct.new(:name, [:pictures]) do

  def pretty_name
    Date.parse(name).strftime("%B %e, %Y")
  rescue
    name
  end

  def sleeves
    pictures.sort_by(&:file).each_slice(3).map { |pictures|
      Sleeve.new(pictures: pictures)
    }
  end
end
