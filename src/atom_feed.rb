require 'rss'

class AtomFeed
  def initialize(rolls)
    @rolls = rolls
  end

  def write_feed(file)
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.author = "David Copeland"
      maker.channel.updated = Time.now.to_s
      maker.channel.about = "http://holgastreet.com/about.html"
      maker.channel.title = "Holgastreet - Pictures of the H St Neighborhood in Washington, D.C."

      @rolls.sort_by(&:name).reject(&:draft?).each do |roll|
        maker.items.new_item do |item|
          item.link = "http://holgastreet.com/rolls/#{roll.name}.html"
          item.title = "Roll #{roll.roll_number}: #{roll.theme}"
          item.content.type = "html"
          item.content.content =  %{
            <img src="/images/holgastreet/#{roll.name}/#{roll.roll_image_thumb_url}" />
            <p>
            #{roll.description}
            </p>
          }
          item.updated = Date.parse(roll.name).to_s
        end
      end
    end
    file.puts rss
  end
end
