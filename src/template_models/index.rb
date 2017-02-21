require "mustache"
module TemplateModels
  class Index < Mustache
    attr_reader :current_roll
    def initialize(rolls)
      @current_roll = rolls.first
    end
  end
end
