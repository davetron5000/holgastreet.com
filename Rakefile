$: << File.join(Dir.pwd,"src")
require "site"
require "rspec/core/rake_task"
require "fileutils"
require "webrick"

task :site do
  Site.new.build!
end
RSpec::Core::RakeTask.new(:spec)

task :default => [ :spec, :site ]

task :serve do
  WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Pathname(Dir.pwd) / "site").start
end
