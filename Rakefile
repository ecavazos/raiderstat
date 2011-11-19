require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'rake'

task :default => :spec

require "rspec/core/rake_task"
desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--format documentation --color]
  t.verbose = false
end

