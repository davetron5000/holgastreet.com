require "mustache"
module TemplateModels
  class RollIndex < Mustache
    attr_reader :rolls
    def initialize(rolls)
      @rolls = rolls
    end
  end
end
