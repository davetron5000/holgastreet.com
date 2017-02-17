require "mustache"
module TemplateModels
  class Index < Mustache
    attr_reader :rolls
    def initialize(rolls)
      @rolls = rolls
    end
  end
end
