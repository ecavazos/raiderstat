require 'spec_helper'
require 'artifice'
require 'dm-migrations'
require 'stat_scraper'

describe "StatScraper" do

  before(:all) do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/stats_test.db")
    DataMapper.auto_migrate!

    responder = lambda { |env|
      p Rack::Request.new(env).url

      stats = '
        <tr>
          <td>1</td>
          <td><a href="">Oakland Raiders</a></td>
        </tr>
      '

      standings = '
        <tr>
          <td>AFC West Team</td>
        </tr>
        <tr>
          <td>Oakland Raiders</td>
          <td>16</td>
          <td>0</td>
        </tr>
        <tr><td>Donkeys</td></tr>
      '

      [200, {}, [stats + standings]]
    }

    Artifice.activate_with responder do
      @stats = StatScraper.new().stats
    end
  end

  it "should have a value for wins" do
    @stats.wins.should == 16
  end

  it "should have a value for losses" do
    @stats.losses.should == 0
  end

  it "should have a value for division rank" do
    @stats.rank.should == 1
  end

  it "should have a value for total offense" do
    @stats.total_offense.should == 1
  end

  it "should have a value for passing offense" do
    @stats.passing_offense.should == 1
  end

  it "should have a value for rushing offense" do
    @stats.rushing_offense.should == 1
  end

  it "should have a value for total defense" do
    @stats.total_defense.should == 1
  end

  it "should have a value for passing defense" do
    @stats.passing_defense.should == 1
  end

  it "should have a value for rushing defense" do
    @stats.rushing_defense.should == 1
  end
end
