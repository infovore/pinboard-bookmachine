require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

set :haml, :format => :html5

set :database, 'sqlite://development.db'


get '/' do
  haml :index
end

get '/year/:year' do
  @year = params[:id].to_i
  @bookmarks = Bookmark.order("bookmarked_at").where("bookmarked_at > ?", DateTime.new(@year,1,1,0,0,0)).where("bookmarked_at < ?", DateTime.new(@year + 1,1,1,0,0,0))
  @bookmarks_by_month = @bookmarks.group_by(&:month)
  haml :year, :layout => :print
end

# models

class Bookmark < ActiveRecord::Base

end
