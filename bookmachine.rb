require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

#thes two are the application broken out a bit.
require 'helpers'
require 'models'

set :haml, :format => :html5
set :database, 'sqlite://development.db'

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

  @title = "A Year of Links: #{@year.year_string}"
  haml :year, :layout => :print
end

