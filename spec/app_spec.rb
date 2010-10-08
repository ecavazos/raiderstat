require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../../app', __FILE__)

App.set :environment, :test

describe 'App' do
  include Rack::Test::Methods

  def app
    App
  end

  it 'should respond to /' do
    get '/'
    last_response.should be_ok
  end

end
