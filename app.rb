require 'rubygems'
require 'bundler'

Bundler.setup unless File.exists?(File.expand_path('../.bundle/environment', __FILE__))
Bundler.require(:default)

require 'sinatra/base'
require "dm-core"
require 'stat_scraper'

class App < Sinatra::Base

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/stats.db")
    DataMapper.auto_migrate!
  end

  get '/' do
    @stats = StatScraper.new().stats
    haml :index
  end
end

