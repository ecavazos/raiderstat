require 'spec_helper'
require 'artifice'
require 'dm-migrations'
require 'stat_scraper'

describe "StatScraper" do

  before do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/stats_test.db")
    DataMapper.auto_migrate!
  end

  def stats opts = {}

    cache = nil

    opts = {
      :position => 1,
      :wins     => 16,
      :losses   => 0,
    }.merge opts

    responder = lambda { |env|
      pos_stats = "
        <tr>
          <td>#{ opts[:position] }</td>
          <td><a href="">Oakland Raiders</a></td>
        </tr>
      "

      # rank = 1
      standings = "
        <tr>
          <td>AFC West Team</td>
        </tr>
        <tr>
          <td>Oakland Raiders</td>
          <td>#{ opts[:wins] }</td>
          <td>#{ opts[:losses] }</td>
        </tr>
        <tr><td>Donkeys</td></tr>
      "

      [200, {}, [pos_stats, standings]]
    }

    Artifice.activate_with responder do
      cache = StatScraper.new().stats
    end

    cache
  end

  it "should have a value for wins" do
    stats(:wins => 16).wins.should == 16
  end

  it "should have a value for losses" do
    stats(:losses => 0).losses.should == 0
  end

  it "should have a value for division rank" do
    stats.rank.should == 1
  end

  it "should have a value for total offense" do
    stats(:position => 2).total_offense.should == 2
  end

  it "should have a value for passing offense" do
    stats(:position => 1).passing_offense.should == 1
  end

  it "should have a value for rushing offense" do
    stats(:position => 3).rushing_offense.should == 3
  end

  it "should have a value for total defense" do
    stats(:position => 2).total_defense.should == 2
  end

  it "should have a value for passing defense" do
    stats(:position => 4).passing_defense.should == 4
  end

  it "should have a value for rushing defense" do
    stats(:position => 2).rushing_defense.should == 2
  end
end
