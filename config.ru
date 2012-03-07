# Gemfile
require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "haml"
require File.expand_path('../bookmachine', __FILE__)

set :run, false
set :raise_errors, true

run Sinatra::Application

