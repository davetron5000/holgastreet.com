require "mustache"
require "forwardable"
module TemplateModels
  class Roll < Mustache
    extend Forwardable

    def initialize(roll)
      @roll = roll
    end

    def_delegators :@roll, :name, :pictures, :theme, :description, :roll_number, :sleeves, :pretty_name, :roll_image_thumb_url

  end
end
