# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# rails 4.0.2 : require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])