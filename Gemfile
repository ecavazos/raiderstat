source 'http://rubygems.org'

gem 'sinatra', '1.0', :require => false

gem 'haml'
gem 'sass'
gem 'nokogiri'
gem 'datamapper', :require => false

group :development do
  gem 'dm-sqlite-adapter'
end

group :production do
  gem 'dm-postgres-adapter'
end

group :test do
  gem 'rack-test'
  gem 'rspec', '2.0.0.rc'
end
