# add lib dir to load path
$:.unshift File.expand_path('../lib', __FILE__)

require File.expand_path('../app', __FILE__)

run App

