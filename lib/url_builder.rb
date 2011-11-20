module URLBuilder
  class << self
    def build(side, stat)
      side_hash = {
        :offense => ['offensiveStatisticCategory', 'TM', 2],
        :defense => ['defensiveStatisticCategory', 'OPP', 1]
      }

      stat_hash = {
        :total   => ['GAME_STATS', 'TOTAL_YARDS_GAME_AVG'],
        :passing => ['TEAM_PASSING', 'PASSING_NET_YARDS_GAME_AVG'],
        :rushing => ['RUSHING', 'RUSHING_YARDS_PER_GAME_AVG']
      }

      si, st = side_hash[side.to_sym], stat_hash[stat.to_sym]

      base = "http://www.nfl.com/stats/categorystats?tabSeq=2"

      "#{ base }&#{ si[0] }=#{ st[0] }&role=#{ si[1] }&d-447263-s=#{ st[1] }&d-447263-o=#{ si[2] }"
    end
  end
end
