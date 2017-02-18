module Logging
  def info(message)
    puts "🔵  #{message}"
  end

  def warn(message)
      puts "⚠️  #{message}"
  end

  def debug(message)
    #puts "🐛  #{message}"
  end

  def cool(message)
    #puts "✅  #{message}"
  end
end
