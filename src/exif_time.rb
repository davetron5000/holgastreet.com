require 'date'
class ExifTime
  def self.parse(string)
    date,time,_ = string.strip.split(/\s+/)
    Date.parse(date.gsub(/:/,-'-'))
  end
end
