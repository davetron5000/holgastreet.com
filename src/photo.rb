require "mustache"
require "forwardable"

class Photo < Mustache
  extend Forwardable
  self.template_path = "templates"

  attr_reader :roll_name
  def initialize(roll,picture)
    @roll_name = roll.name
    @picture = picture
  end

  def_delegators :@picture, :url, :thumb_url, :taken_on_pretty, :film_type, :iso, :coordinate, :description

end
