module URLBuilder
  class << self
    def build(side, stat)
      side = side.to_sym
      stat = stat.to_sym

      type = {
        :offense => 'offensiveStatisticCategory',
        :defense => 'defensiveStatisticCategory'
      }
      role = {
        :offense => 'TM',
        :defense => 'OPP'
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

      "#{base}&#{type[side]}=#{stat1[stat]}&role=#{role[side]}&d-447263-s=#{stat2[stat]}&d-447263-o=#{sort[side]}"
    end
  end
end
