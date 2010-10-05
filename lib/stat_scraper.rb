require 'open-uri'
require 'pstore'
require 'nokogiri'
require 'url_builder'

class StatScraper

  def initialize
    @data = PStore.new('stats.pstore')
  end

  def stats
    # get row
    # //a[text()='Oakland Raiders']/ancestor::tr

    @data.transaction do
      s = {
        :total_offense   => league_stats(:side => :offense, :stat => :total),
        :passing_offense => league_stats(:side => :offense, :stat => :passing),
        :rushing_offense => league_stats(:side => :offense, :stat => :rushing),
        :total_defense   => league_stats(:side => :defense, :stat => :total),
        :passing_defense => league_stats(:side => :defense, :stat => :passing),
        :rushing_defense => league_stats(:side => :defense, :stat => :rushing)
      }

      s.merge!(standings())
    end
  end

  private

  def standings
    url = "http://www.nfl.com/standings"
    sel = "//td[text()='AFC West Team']/ancestor::tr/following-sibling::tr"

    if cache_expired?
      i = 1

      Nokogiri::HTML(open(url)).xpath(sel).each do |tr|
        if tr.children[0].to_s =~ /Oak/
          @data[:wins]   = tr.children[2].text
          @data[:losses] = tr.children[4].text
          @data[:rank]   = i
        end
        i += 1
      end
    end

    h = {
      :wins   => @data[:wins],
      :losses => @data[:losses],
      :rank   => @data[:rank]
    }
  end

  def league_stats(params)
    side = params[:side]
    stat = params[:stat]

    url = URLBuilder.build(side, stat)

    sel = "//a[text()='Oakland Raiders']/ancestor::td/preceding-sibling::td"

    key = "#{stat}_#{side}".to_sym

    if @data[key].nil? || cache_expired?
      @data[key] = Nokogiri::HTML(open(url)).xpath(sel).text
    end

    @data[key]
  end

  def cache_expired?
    @data[:last_updated].nil? || (Time.now - @data[:last_updated]) % 24 >= 24
  end
end
