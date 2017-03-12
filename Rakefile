$: << File.join(Dir.pwd,"src")
require "site"
require "rspec/core/rake_task"
require "fileutils"
require "webrick"

task :site do
  Site.new.build!
end

task :deploy => :site do
  fail "Must be run from root" unless Dir.exist?("site")
  [
    "--exclude=\"*.html\"                      --cache-control=\"max-age=604800\"",
    "--exclude=\"*\"      --include=\"*.html\" --cache-control=\"max-age=3600\"",
    "--exclude=\"*\"      --include=\"*.xml\" --cache-control=\"max-age=3600\"",
  ].each do |args|
    command = "aws s3 sync #{args} --profile=personal site/ s3://holgastreet.com"
    puts command
    sh(command) do |ok,res|
      fail res.inspect unless ok
    end
  end
end

RSpec::Core::RakeTask.new(:spec)

task :default => [ :spec, :site ]

task :serve do
  WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Pathname(Dir.pwd) / "site").start
end

task :prep, [:rollname,:skips] do |t,args|
  rollname = args[:rollname]
  skips = (args[:skips] || "").split(/,/)

  FileUtils.mkdir_p "original_images/#{rollname}"
  chdir "original_images/#{rollname}" do
    puts "Rotate, Crop, and Desaturate in Preview. Hit Return when done."
    $stdin.gets
    puts "Rename files and move to original_images/#{rollname}/.  Hit Return when done."
    $stdin.gets
    unless skips.include?("film")
      puts "Film?"
      film = $stdin.gets.chomp
      puts "ISO?"
      iso = $stdin.gets.chomp
      command = "exiftool -Make=\"#{film}\" -ISO=#{iso} -Model=\"Holga 120N\" -Keywords=\"holga, Holgastreet roll:#{rollname}\" -Subject=\"holga, Holgastreet roll:#{rollname}\" *.jpeg"
      unless system(command)
        fail "Problem running '#{command}'"
      end
    end
    previous_date = nil
    Dir["*.jpeg"].each do |file|
      puts "Fixing up #{file}"
      system("open #{file}")
      puts "When taken? #{previous_date}"
      date = $stdin.gets.chomp
      raise if date.strip == "" && previous_date.nil?
      previous_date = date
      date = "#{date} 12:00:00" if date =~ /^\d\d\d\d:\d\d:\d\d$/
      puts "lat/long?"
      lat_long = $stdin.gets.chomp
      lat,long = lat_long.split(/\s+/)
      title = file.gsub(/.jpeg$/,'').gsub!(/(.)([A-Z])/,'\1 \2')
      puts "Title? #{title}"
      new_title = $stdin.gets.chomp
      if new_title != ""
        title = new_title
      end
      puts "Description?"
      desc = $stdin.gets.chomp

      command = "exiftool -Title=\"#{title}\" -Description=\"#{desc}\" -AllDates=\"#{date}\" -exif:gpslatituderef=N -exif:gpslongituderef=W -exif:gpslatitude=#{lat} -exif:gpslongitude=#{long} #{file}"
      unless system(command)
        fail "Problem running '#{command}'"
      end
    end
  end

end
