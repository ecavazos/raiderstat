require 'spec_helper'
require './app'

App.set :environment, :test

describe "App" do
  include Rack::Test::Methods
  include Capybara::DSL

  Capybara.app = App

  before :all do
    DataMapper.setup(:default, "sqlite3://#{ Dir.pwd }/stats_test.db")
    DataMapper.auto_migrate!
    Cache.create({
      :rank            => 1,
      :wins            => 16,
      :losses          => 0,
      :total_offense   => 1,
      :passing_offense => 1,
      :rushing_offense => 1,
      :total_defense   => 1,
      :passing_defense => 1,
      :rushing_defense => 1,
      :updated         => Time.now
    })
  end

  before do
    visit '/'
  end

  it "should have a title of 'RaiderStat'" do
    find('title').text.should == 'RaiderStat'
  end

  it "should have correct header" do
    find('h1').text.should == 'How are my Raiders this year?'
  end

  it "should have logo" do
    within '#logo' do
      find('img')[:alt].should == 'Oakland Raiders'
      find('img')[:src].should == '/images/logo.png'
    end
  end

  it "should have stats" do
    page.should have_content('Record:')
    find('.record').text.should == '16 - 0'

    page.should have_content('Division Rank:')
    find('.rank').text.should == '1'

    page.should have_content('Total Offense:')
    find('.total_offense').text.should == '#1'

    page.should have_content('Passing Offense:')
    find('.passing_offense').text.should == '#1'

    page.should have_content('Rushing Offense:')
    find('.rushing_offense').text.should == '#1'

    page.should have_content('Total Defense:')
    find('.total_defense').text.should == '#1'

    page.should have_content('Passing Defense:')
    find('.passing_defense').text.should == '#1'

    page.should have_content('Rushing Defense:')
    find('.rushing_defense').text.should == '#1'
  end

  it "should have an author credit" do
    within '#footer' do
      page.should have_content('Created by Emilio Cavazos')
    end
  end
end
