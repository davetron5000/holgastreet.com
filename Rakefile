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
