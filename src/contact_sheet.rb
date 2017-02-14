require "immutable-struct"
require_relative "./sleeve"

ContactSheet = ImmutableStruct.new(:date, [:pictures]) do

  def name
    date.strftime("%B %e, %Y")
  end

  def sleeves
    pictures.sort_by(&:file).each_slice(3).map { |pictures|
      Sleeve.new(pictures: pictures)
    }
  end
end
