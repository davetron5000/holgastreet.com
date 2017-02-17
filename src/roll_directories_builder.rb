require 'fileutils'
require 'pathname'
require_relative "logging"

class RollDirectoriesBuilder
  include Logging
  include FileUtils

  def initialize(images_dir)
    @images_dir = Pathname(images_dir)
  end

  def build_roll_directories(original_images)
    original_images.map(&:roll_name).uniq.map { |dir|
      @images_dir / dir
    }.each do |dir|
      info "Creating roll dir #{dir}"
      mkdir_p(dir)
    end
  end
end
