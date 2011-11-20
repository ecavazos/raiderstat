require 'open-uri'
require 'dm-core'
require 'nokogiri'
require 'url_builder'
require 'cache'

class StatScraper

  def initialize
    @cache = Cache.first || Cache.new
  end

  def stats
    return @cache unless cache_expired?

    league_stats :side => :offense, :stat => :total
    league_stats :side => :offense, :stat => :passing
    league_stats :side => :offense, :stat => :rushing
    league_stats :side => :defense, :stat => :total
    league_stats :side => :defense, :stat => :passing
    league_stats :side => :defense, :stat => :rushing

    standings

    @cache.updated = Time.now
    @cache.save
    @cache
  end

  private

  def standings
    url = "http://www.nfl.com/standings"
    sel = "//td[text()='AFC West Team']/ancestor::tr/following-sibling::tr"

    i = 1

    Nokogiri::HTML( open(url) ).xpath(sel).each do |tr|
      if tr.children[0].to_s =~ /Oak/
        @cache.wins   = tr.children[2].text
        @cache.losses = tr.children[4].text
        @cache.rank   = i
      else
        i += 1
      end
    end
  end

  def league_stats(params)
    side = params[:side]
    stat = params[:stat]

    url = URLBuilder.build(side, stat)

    sel = "//a[text()='Oakland Raiders']/ancestor::td/preceding-sibling::td"

    key = "#{stat}_#{side}".to_sym

    if @cache[key].nil? || cache_expired?
      page = open url
      @cache[key] = Nokogiri::HTML(page).xpath(sel).text
    end

    @cache[key]
  end

  def cache_expired?
    secs_in_day = ( 24 * 60 * 60 )
    @cache.updated.nil? || (Time.now - @cache.updated.to_time) / secs_in_day >= 1
  end
end

