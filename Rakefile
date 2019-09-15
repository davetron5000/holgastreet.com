$: << File.join(Dir.pwd,"src")
require "site"
require "rspec/core/rake_task"
require "fileutils"
require "webrick"
require "geocoder"

task :geo do
  Geocoder.configure(

    # street address geocoding service (default :nominatim)
    lookup: :google,

    # IP address geocoding service (default :ipinfo_io)
    ip_lookup: :maxmind,

    # to use an API key:
    api_key: ENV["GOOGLE_API_KEY"],

    # geocoding service request timeout, in seconds (default 3):
    timeout: 5,

      # set default units to kilometers:
      units: :mi,
  )
  puts Geocoder.search("Maui, HI").first.coordinates
end

desc "Build the site locally"
task :site do
  rolls_filename = if ENV["DEV"] == "true"
                     "rolls-dev.json"
                   else
                     "rolls.json"
                   end
  Site.new(rolls_filename).build!
end

desc "Deploy site to AWS"
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

desc "Serve the site locally (does not build)"
task :serve do
  WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Pathname(Dir.pwd) / "site").start
end
