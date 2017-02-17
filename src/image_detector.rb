require "pathname"
require_relative "logging"
require_relative "original_image"

class ImageDetector
  include Logging
  def initialize(original_image_dir)
    @original_image_dir = Pathname(original_image_dir)
  end
  def detect_images
    info "Detecting images..."
    Dir[@original_image_dir / "*"].select { |file|
      file =~ /\.jpg$/i || file =~ /.jpeg$/i
    }.map  { |file|
      debug "Detected #{file}"
      OriginalImage.new(file)
    }
  end
end
