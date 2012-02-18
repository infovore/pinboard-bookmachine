require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

set :haml, :format => :html5

set :database, 'sqlite://development.db'


get '/' do
  haml :index
end

get '/stylesheets/:stylesheet.css' do
  scss params[:stylesheet].to_sym
end

get '/year/:year' do
  @year = params[:year].to_i
  @bookmarks = Bookmark.order("bookmarked_at").where("bookmarked_at > ?", DateTime.new(@year,1,1,0,0,0)).where("bookmarked_at < ?", DateTime.new(@year + 1,1,1,0,0,0))
  @bookmarks_by_month = @bookmarks.group_by(&:month)

  @title = "A Year of Links: #{@year}"
  haml :year, :layout => :print
end

# helpers

helpers do
  def link_to(*args, &block)
  end

  def format_date(date)
    date.strftime("%d %B %Y")
  end

  def mark_hash(string)
    Digest::MD5.hexdigest(string)
  end

  def id_for_tag(tag_string, previous_tags_array)
    if previous_tags_array.include?(tag_string)
      previous_tags_array << tag_string
      count = previous_tags_array.count(tag_string)
      ["#{tag_string}-#{count}",previous_tags_array]
    else
      previous_tags_array << tag_string
      ["#{tag_string}-1", previous_tags_array]
    end
  end

  def volume_number_for_year(year)
    year.to_i - 2004 + 1
  end  
end

# models

class Bookmark < ActiveRecord::Base
  def tags
    raw_tags.split(" ")
  end

  def month
    bookmarked_at.strftime('%B')
  end

  def day
    bookmarked_at.strftime("%d")
  end

  def qr_for_url
    "http://qrcode.kaywa.com/img.php?s=8&d=#{CGI.escape(href)}"
  end
  
end
