# frozen_string_literal: true

# Require the local "version", not one that may be already installed.
require File.join([File.dirname(__FILE__), 'lib', 'octool', 'version.rb'])
require 'date'

spec = Gem::Specification.new do |s| # rubocop:disable Lint/UselessAssignment
    s.name = 'octool'
    s.version = OCTool::VERSION
    s.date = Date.today.strftime('%Y-%m-%d')
    s.author = 'Paul Morgan'
    s.email = 'jumanjiman@gmail.com'
    s.homepage = 'https://github.com/jumanjiman/octool'
    s.license = 'GPL-3.0'
    s.platform = Gem::Platform::RUBY
    s.summary = 'Open Compliance Toolkit'
    s.files = `find bin lib schemas templates -type f`.split($RS)
    s.require_paths << 'lib'
    s.extra_rdoc_files = ['README.rdoc', 'octool.rdoc']
    s.rdoc_options << '--title' << 'octool' << '--main' << 'README.rdoc' << '-ri'
    s.bindir = 'bin'
    s.executables << 'octool'
    s.required_ruby_version = '>= 2.4'
    s.add_development_dependency('rake', '>= 13.0', '< 13.1')
    s.add_development_dependency('rdoc', '>= 6.2', '< 6.3')
    s.add_runtime_dependency('daru', '0.2.2')
    s.add_runtime_dependency('etc', '1.1.0')
    s.add_runtime_dependency('gli', '2.19.0')
    s.add_runtime_dependency('json_pure', '2.3.0')
    s.add_runtime_dependency('kwalify', '0.7.2')
    s.add_runtime_dependency('pandoc-ruby', '2.1.4')
    s.add_runtime_dependency('paru', '0.4.0.1')
end
