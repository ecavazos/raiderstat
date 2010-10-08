require File.expand_path('../../spec_helper', __FILE__)
require 'dm-migrations'
require 'stat_scraper'

describe "StatScraper" do

  before(:all) do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/stats_test.db")
    DataMapper.auto_migrate!
    @stats = StatScraper.new().stats
  end

  def should_be_in_range(val, x, y)
    (val > x).should be_true
    (val < y).should be_true
  end

  it "should have a value for wins" do
    should_be_in_range(@stats.wins, -1, 17)
  end

  it "should have a value for losses" do
    should_be_in_range(@stats.losses, -1, 17)
  end

  it "should have a value for division rank" do
    should_be_in_range(@stats.rank, 1, 5)
  end

  it "should have a value for total offense" do
    should_be_in_range(@stats.total_offense, 0, 33)
  end

  it "should have a value for passing offense" do
    should_be_in_range(@stats.passing_offense, 0, 33)
  end

  it "should have a value for rushing offense" do
    should_be_in_range(@stats.rushing_offense, 0, 33)
  end

  it "should have a value for total defense" do
    should_be_in_range(@stats.total_defense, 0, 33)
  end

  it "should have a value for passing defense" do
    should_be_in_range(@stats.passing_defense, 0, 33)
  end

  it "should have a value for rushing defense" do
    should_be_in_range(@stats.rushing_defense, 0, 33)
  end
end
