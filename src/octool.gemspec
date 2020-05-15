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
end
