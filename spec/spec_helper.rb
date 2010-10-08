require 'rubygems'
require 'rack/test'

# absolute path to lib folder
lib_dir = File.expand_path('../../lib', __FILE__)

# insert lib folder into load_paths if it's not already
$:.unshift lib_dir unless $:.include?(lib_dir)


