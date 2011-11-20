require 'spec_helper'

describe "URLBuilder" do

  it "should have an nfl.com base url" do
    url = URLBuilder.build(:offense, :total)
    url.start_with?("http://www.nfl.com/stats/categorystats?tabSeq=2").should be_true
  end

  describe "building offense URLs" do

    before do
      @url = URLBuilder.build(:offense, :total)
    end

    it "should have an offense stat variable" do
      @url.should include("&offensiveStatisticCategory=")
    end

    it "should set the role variable to TM" do
      @url.should include("role=TM")
    end

    it "should set a sort value for offensive stats" do
      @url.should include("&d-447263-o=2")
    end
  end

  describe "building defense URLs" do

    before do
      @url = URLBuilder.build(:defense, :total)
    end

    it "should have a defense stat variable" do
      @url.should include("&defensiveStatisticCategory=")
    end

    it "should set the role variable to OPP" do
      @url.should include("role=OPP")
    end

    it "should set a sort value for defensive stats" do
      @url.should include("&d-447263-o=1")
    end
  end

  describe "building total stats URLs" do

    before do
      @url = URLBuilder.build(:offense, :total)
    end

    it "should have a game stats value" do
      @url.should include("&offensiveStatisticCategory=GAME_STATS")
    end

    it "should have a total yards a game value" do
      @url.should include("&d-447263-s=TOTAL_YARDS_GAME_AVG")
    end
  end

  describe "building offensive passing stats URLs" do

    before do
      @url = URLBuilder.build(:offense, :passing)
    end

    it "should have a team passing value" do
      @url.should include("&offensiveStatisticCategory=TEAM_PASSING")
    end

    it "should have a passing net value" do
      @url.should include("&d-447263-s=PASSING_NET_YARDS_GAME_AVG")
    end
  end

  describe "building offensive rushing stats URLs" do

    before do
      @url = URLBuilder.build(:offense, :rushing)
    end

    it "should have a team rushing value" do
      @url.should include("&offensiveStatisticCategory=RUSHING")
    end

    it "should have a rushing net value" do
      @url.should include("&d-447263-s=RUSHING_YARDS_PER_GAME_AVG")
    end
  end

  describe "building defensive passing stats URLs" do

    before do
      @url = URLBuilder.build(:defense, :passing)
    end

    it "should have a team passing value" do
      @url.should include("&defensiveStatisticCategory=TEAM_PASSING")
    end

    it "should have a passing net value" do
      @url.should include("&d-447263-s=PASSING_NET_YARDS_GAME_AVG")
    end
  end

  describe "building defensive rushing stats URLs" do

    before do
      @url = URLBuilder.build(:defense, :rushing)
    end

    it "should have a team rushing value" do
      @url.should include("&defensiveStatisticCategory=RUSHING")
    end

    it "should have a rushing net value" do
      @url.should include("&d-447263-s=RUSHING_YARDS_PER_GAME_AVG")
    end
  end
end

