require 'open-uri'
require 'dm-core'
require 'nokogiri'
require 'url_builder'
require 'cache'

class StatScraper

  def initialize
    @data = Cache.first || Cache.create
  end

  def stats
    if cache_expired?
      league_stats(:side => :offense, :stat => :total)
      league_stats(:side => :offense, :stat => :passing)
      league_stats(:side => :offense, :stat => :rushing)
      league_stats(:side => :defense, :stat => :total)
      league_stats(:side => :defense, :stat => :passing)
      league_stats(:side => :defense, :stat => :rushing)
      standings()
      @data.updated = Time.now
      @data.save
    end

    @data
  end

  private

  def standings
    url = "http://www.nfl.com/standings"
    sel = "//td[text()='AFC West Team']/ancestor::tr/following-sibling::tr"

    i = 1

    Nokogiri::HTML(open(url)).xpath(sel).each do |tr|
      if tr.children[0].to_s =~ /Oak/
        @data.wins   = tr.children[2].text
        @data.losses = tr.children[4].text
        @data.rank   = i
      end
      i += 1
    end
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
    @data.updated.nil? || (Time.now.to_i - @data.updated.to_time.to_i) % 24 >= 24
  end
end
