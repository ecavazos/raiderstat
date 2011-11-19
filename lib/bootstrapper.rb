require 'rubygems'
require 'bundler'

Bundler.setup unless File.exists?(File.expand_path('../.bundle/environment', __FILE__))
Bundler.require(:default)

require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require 'stat_scraper'

