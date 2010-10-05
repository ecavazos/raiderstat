require 'rubygems'
require 'open-uri'
require 'bundler'

Bundler.setup unless File.exists?(File.expand_path('../.bundle/environment', __FILE__))
Bundler.require(:default)

require 'sinatra/base'
require 'stat_scraper'

class App < Sinatra::Base

  get '/' do

#    class Nokogiri::HTML::Document
#        class DocStub
#          def text; 4 end
#        end
#      def xpath(*)
#        DocStub.new
#      end
#    end

    stats = StatScraper::stats

    @tot_off = stats[:total_offense]
    @off_pas = stats[:passing_offense]
    @off_rus = stats[:rushing_offense]
    @tot_def = stats[:total_defense]
    @def_pas = stats[:passing_defense]
    @def_rus = stats[:rushing_defense]

    std = StatScraper::standings

    @wins   = std[:wins]
    @losses = std[:losses]
    @rank   = std[:rank]

    haml :index
  end
end

