require File.expand_path('../../spec_helper', __FILE__)
require 'dm-migrations'
require 'stat_scraper'

describe "StatScraper" do

  before(:all) do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/stats_test.db")
    DataMapper.auto_migrate!
    @stats = StatScraper.new().stats
  end

  it "should have a value for wins" do
    (@stats.wins >= 0).should be_true
    (@stats.wins < 17).should be_true
  end

  it "should have a value for losses" do
    (@stats.losses >= 0).should be_true
    (@stats.losses < 17).should be_true
  end

  it "should have a value for division rank" do
    (@stats.rank > 1).should be_true
    (@stats.rank < 5).should be_true
  end

  it "should have a value for total offense" do
    (@stats.total_offense > 0).should be_true
    (@stats.total_offense < 33).should be_true
  end

  it "should have a value for passing offense" do
    (@stats.passing_offense > 0).should be_true
    (@stats.passing_offense < 33).should be_true
  end

  it "should have a value for rushing offense" do
    (@stats.rushing_offense > 0).should be_true
    (@stats.rushing_offense < 33).should be_true
  end

  it "should have a value for total defense" do
    (@stats.total_defense > 0).should be_true
    (@stats.total_defense < 33).should be_true
  end

  it "should have a value for passing defense" do
    (@stats.passing_defense > 0).should be_true
    (@stats.passing_defense < 33).should be_true
  end

  it "should have a value for rushing defense" do
    (@stats.rushing_defense > 0).should be_true
    (@stats.rushing_defense < 33).should be_true
  end
end
