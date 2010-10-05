require 'open-uri'
require 'pstore'
require 'nokogiri'

module StatScraper
  class << self
    def standings
      url = "http://www.nfl.com/standings"
      sel = "//td[text()='AFC West Team']/ancestor::tr/following-sibling::tr"

      data = PStore.new('stats.pstore')

      h = {}

      data.transaction do
        if data[:last_updated].nil? || (Time.now - data[:last_updated]) % 24 >= 24
          i = 1

          Nokogiri::HTML(open(url)).xpath(sel).each do |tr|
            if tr.children[0].to_s =~ /Oak/
              data[:wins]   = tr.children[2].text
              data[:losses] = tr.children[4].text
              data[:rank]   = i
              data[:last_updated] = Time.now
            end
            i += 1
          end

        end

        h[:wins] = data[:wins]
        h[:losses] = data[:losses]
        h[:rank] = data[:rank]
      end

      h
    end

    def league_stats(params)
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

      selector = "//a[text()='Oakland Raiders']/ancestor::td/preceding-sibling::td"

      Nokogiri::HTML(open(url)).xpath(selector).text
    end

    def stats
      # get row
      # //a[text()='Oakland Raiders']/ancestor::tr

      s = {
        :total_offense   => self.league_stats(:side => :offense, :stat => :total),
        :passing_offense => self.league_stats(:side => :offense, :stat => :passing),
        :rushing_offense => self.league_stats(:side => :offense, :stat => :rushing),
        :total_defense   => self.league_stats(:side => :defense, :stat => :total),
        :passing_defense => self.league_stats(:side => :defense, :stat => :passing),
        :rushing_defense => self.league_stats(:side => :defense, :stat => :rushing)
      }
    end
  end
end
