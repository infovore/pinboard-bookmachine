require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

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

# helpers

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
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

end

# models
class Year < ActiveRecord::Base
  has_many :bookmarks, :order => :bookmarked_at

  def volume_number
    year_string.to_i - 2004 + 1
  end  
end

class Bookmark < ActiveRecord::Base
  belongs_to :year

  def tags
    raw_tags.split(" ")
  end
  
  def year
    bookmarked_at.strftime('%Y')
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
