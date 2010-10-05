require 'rubygems'
require 'open-uri'
require 'bundler'

Bundler.setup unless File.exists?(File.expand_path('../.bundle/environment', __FILE__))
Bundler.require(:default)

require 'sinatra/base'
require 'stat_scraper'

class App < Sinatra::Base

  get '/' do
    @stats = StatScraper.new().stats
    haml :index
  end
end

