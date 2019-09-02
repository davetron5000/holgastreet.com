require "mustache"
require "forwardable"
module TemplateModels
  class Photo < Mustache
    extend Forwardable

    attr_reader :roll_name, :previous_picture_url, :next_picture_url
    def initialize(roll, picture, previous_picture_url, next_picture_url)
      @roll_name            = roll.name
      @picture              = picture
      @previous_picture_url = previous_picture_url
      @next_picture_url     = next_picture_url
    end

    def_delegators :@picture, :url, :thumb_url, :taken_on_pretty, :film_type, :iso, :coordinate, :description, :title

  end
end
