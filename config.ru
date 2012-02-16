# Gemfile
require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "haml"
require "bookmachine"

set :run, false
set :raise_errors, true

run Sinatra::Application

