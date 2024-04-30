# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:test)

  task default: :test
rescue LoadError
  puts 'No rspec available'
end

desc 'Build a gem off the gemspec'
task :build do
  sh 'gem build imbox.gemspec'
end

desc 'Install the latest version imbox gem'
task :install do
  versions = Dir.glob('*.gem').map do |gem_name|
    gem_name.split('-').last[0...-4]
  end

  latest_version = versions.sort_by { |v| Gem::Version.new(v) }.pop

  gem_name = Dir.glob("*-#{latest_version}.*").pop

  sh "gem install ./#{gem_name}"
end

desc 'Build and install imbox'
task :reload do
  Rake::Task['build'].execute
  Rake::Task['install'].execute
end
