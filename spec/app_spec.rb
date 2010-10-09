require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../../app', __FILE__)

App.set :environment, :test

describe "App" do
  include Rack::Test::Methods

  def app
    App
  end

  before(:all) do
    get '/'
    @body = last_response.body.gsub(/\s+/, ' ')
  end

  it "should respond to /" do
    last_response.should be_ok
  end

  it "should have a title of 'RaiderStat'" do
    expected = "<title>RaiderStat</title>"
    @body.include?(expected).should be_true
  end

  it "should have correct header" do
    expected = "<h1>How are my Raiders this year?<\/h1>"
    @body.include?(expected).should be_true
  end

  it "should have logo" do
    expected = "<div id='logo'> <img alt='Oakland Raiders' src='/images/raiders_logo.png' /> </div>"
    @body.include?(expected).should be_true
  end

  it "should have division rank" do
    expected = /<dt>.+Division\sRank:.+<\/dt>.+<dd>.+\d.+<\/dd>/mx
    last_response.body.should match(expected)
  end

  it "should have an author credit" do
    expected = "<div id='footer'> Created by Emilio Cavazos </div>"
    @body.include?(expected).should be_true
  end
end
