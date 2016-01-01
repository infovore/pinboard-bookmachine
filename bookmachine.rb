require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

#thes two are the application broken out a bit.
require File.expand_path('../helpers', __FILE__)
require File.expand_path('../models', __FILE__)

set :haml, :format => :html5
set :database, {adapter: "sqlite3", database: "development.db"}


AUTHOR_NAME = "Tom Armitage"
PINBOARD_USERNAME = "infovore"
BOOK_TITLE = "A Year of Links"

get '/' do
  @years = Year.order("year_string")
  haml :index
end

get '/stylesheets/:stylesheet.css' do
  scss params[:stylesheet].to_sym
end

get '/year/:year' do
  @year = Year.where(:year_string => params[:year]).first
  @bookmarks = @year.bookmarks 
  @bookmarks_by_month = @bookmarks.group_by(&:month)

  @title = "#{BOOK_TITLE}: #{@year.year_string}"
  haml :year, :layout => :print
end

