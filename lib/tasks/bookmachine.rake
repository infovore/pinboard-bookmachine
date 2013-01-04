STDOUT.sync = true

task :default => "ingest:all"

task :environment do
  require 'rubygems'
  require 'sinatra'
  require 'sinatra/activerecord'
  require 'nokogiri'
  require File.expand_path('../../../bookmachine', __FILE__)
end

namespace :ingest do
  task :all => [:ingest_pinboard, :tidy_utm, :cache_years]

  desc "Ingest all pinboard bookmarks"
  task :ingest_pinboard => :environment do
    puts "Ingesting bookmarks"
    file = File.read("data/pinboard_all.xml")
    doc = Nokogiri::XML(file)
    doc.css("post").each do |post|
      b = Bookmark.new
      b.href = post.attr("href")
      b.description = post.attr("description")
      b.extended = post.attr("extended")
      b.bookmark_hash = post.attr("hash")
      b.meta = post.attr("meta")
      b.bookmarked_at = Time.parse(post.attr("time"))
      b.raw_tags = post.attr("tag")
      b.created_at = Time.now
      
      b.save
      print "."
    end
  puts
  end

  desc "Tidy utm data from bookmarks."
  task :tidy_utm => :environment do
    puts "Removing analytics tracking query strings."
    bookmarks = Bookmark.all
    bookmarks.each do |bookmark|
      if bookmark.href =~ /utm/
        bookmark.href = bookmark.href.gsub(/\?utm_source.*/, "")
        bookmark.save
        print "."
      else
        print "x"
      end
    end
    puts     
  end

  desc "Cache years for bookmarks"
  task :cache_years => :environment do
    bookmarks = Bookmark.all
    bookmarks.each do |bookmark|
      year = Year.find_or_create_by_year_string(bookmark.year)
      bookmark.year = year
      bookmark.save
    end
  end

end

namespace :publish do
  desc "Render all books as PDFs to app root."
  task :all => :environment do
    years = Year.all
    years.each do |y|
      year = y.year_string
      `prince http://localhost:9292/year/#{year} -o output/#{year}.pdf`
    end
  end

  desc "Render a specific year"
  task :year => :environment do
    if ENV["YEAR"]
      if Year.find_by_year_string(ENV["YEAR"])
        `prince http://localhost:9292/year/#{ENV['YEAR']} -o output/#{ENV['YEAR']}.pdf`
      else
        puts "That year could not be found."
      end
    else
      puts "Please specify a year eg YEAR=1999"
    end
  end
end
