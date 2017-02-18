require "json"

class RollDataFile
  def initialize(file_path)
    @roll_data = JSON.parse(File.read(file_path))["rolls"]
  end

  def roll_data(roll_name)
    @roll_data.detect { |roll_data|
      roll_data["name"] == roll_name
    } || {}
  end
end
