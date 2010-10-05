class Cache
  include DataMapper::Resource

  property :id,              Serial
  property :wins,            Integer
  property :losses,          Integer
  property :rank,            Integer
  property :total_offense,   Integer
  property :passing_offense, Integer
  property :rushing_offense, Integer
  property :total_defense,   Integer
  property :passing_defense, Integer
  property :rushing_defense, Integer
  property :updated,         DateTime

end

