require "mustache"
class Index < Mustache
  self.template_path = "templates"

  attr_reader :rolls
  def initialize(rolls)
    @rolls = rolls
  end
end
