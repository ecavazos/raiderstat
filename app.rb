require 'rubygems'
require 'open-uri'
require 'bundler'

Bundler.setup unless File.exists?(File.expand_path('../.bundle/environment', __FILE__))
Bundler.require(:default)

require 'sinatra/base'

class App < Sinatra::Base

  def standings
    url = "http://www.nfl.com/standings"
    sel = "//td[text()='AFC West Team']/ancestor::tr/following-sibling::tr"

    i = 1
    h = {}
    Nokogiri::HTML(open(url)).xpath(sel).each do |tr|
      if tr.children[0].to_s =~ /Oak/
        h[:wins]   = tr.children[2].text
        h[:losses] = tr.children[4].text
        h[:rank]   = i
      end
      i += 1
    end
    h
  end

  def stats(params)
    side = params[:side]
    stat = params[:stat]

    role = {
      :offense => 'TM',
      :defense => 'OPP'
    }
    type = {
      :offense => 'offensiveStatisticCategory',
      :defense => 'defensiveStatisticCategory'
    }
    sort = {
      :offense => 2,
      :defense => 1
    }
    stat1 = {
      :total => 'GAME_STATS',
      :passing => 'TEAM_PASSING',
      :rushing => 'RUSHING'
    }
    stat2 = {
      :total   => 'TOTAL_YARDS_GAME_AVG',
      :passing => 'PASSING_NET_YARDS_GAME_AVG',
      :rushing => 'RUSHING_YARDS_PER_GAME_AVG'
    }

    base = "http://www.nfl.com/stats/categorystats?tabSeq=2"

    url = "#{base}&#{type[side]}=#{stat1[stat]}&role=#{role[side]}&d-447263-s=#{stat2[stat]}&d-447263-o=#{sort[side]}"

    Nokogiri::HTML(open(url))
  end

  get '/' do

#    class Nokogiri::HTML::Document
#        class DocStub
#          def text; 4 end
#        end
#      def xpath(*)
#        DocStub.new
#      end
#    end

    # get row
    # //a[text()='Oakland Raiders']/ancestor::tr
    selector = "//a[text()='Oakland Raiders']/ancestor::td/preceding-sibling::td"

    @tot_off = stats(:side => :offense, :stat => :total).xpath(selector).text
    @off_pas = stats(:side => :offense, :stat => :passing).xpath(selector).text
    @off_rus = stats(:side => :offense, :stat => :rushing).xpath(selector).text
    @tot_def = stats(:side => :defense, :stat => :total).xpath(selector).text
    @def_pas = stats(:side => :defense, :stat => :passing).xpath(selector).text
    @def_rus = stats(:side => :defense, :stat => :rushing).xpath(selector).text

    std = standings
    @wins   = std[:wins]
    @losses = std[:losses]
    @rank   = std[:rank]

    haml :index
  end
end

