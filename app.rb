require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require 'stat_scraper'

class App < Sinatra::Base

  configure do
    set :app_file, __FILE__
    set :logging, Proc.new { !test? }
    set :run, Proc.new { !test? }
    set :dump_errors, true
    set :haml, {:format => :html5 }

    DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/stats.db")
    DataMapper.auto_migrate!
  end

  get '/' do
    @stats = StatScraper.new().stats
    haml :index
  end
end

