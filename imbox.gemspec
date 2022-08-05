require File.expand_path('lib/imbox/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'imbox'
  spec.version = Imbox::VERSION
  spec.summary = 'A command line .mbox file browser'
  spec.description = <<-EOF
    Opens an .mbox file in the command line for opening,
    reading, and deleting emails represented in the file.
  EOF
  spec.authors = ['Jon Seay']
  spec.homepage = "https://github.com/jonnypolite/imbox"
  spec.license = 'MIT'

  spec.files = Dir.glob('lib/**/*.rb')
  spec.executables << 'imbox'

  spec.add_dependency 'curses', '~> 1.4.4'
  spec.add_dependency 'mbox', '~> 0.1.0'

  spec.add_development_dependency 'rspec', '~> 3.11'
  # TODO
  # spec.email = "make an alias first"
end
