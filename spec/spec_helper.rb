require 'rubygems'
require 'rack/test'
require 'capybara/rspec'


Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

