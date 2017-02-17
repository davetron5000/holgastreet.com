$: << File.join(Dir.pwd,"src")
require 'site'
require 'rspec/core/rake_task'

task :site do
  Site.new.build!
end
RSpec::Core::RakeTask.new(:spec)

task :default => [ :spec, :site ]

