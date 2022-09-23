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
  gem_file = Dir.glob('*.gem').last

  sh "gem install ./#{gem_file}"
end

desc 'Build and install imbox'
task :reload do
  Rake::Task['build'].execute
  Rake::Task['install'].execute
end
