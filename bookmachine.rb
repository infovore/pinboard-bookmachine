set :haml, :format => :html5

set :database, 'sqlite://development.db'

get '/' do
  haml :index
end

get '/year/:year' do
  #convert this to using Sequel.
  #@year = params[:id].to_i
  #@bookmarks = Bookmark.order("bookmarked_at").where("bookmarked_at > ?", DateTime.new(@year,1,1,0,0,0)).where("bookmarked_at < ?", DateTime.new(@year + 1,1,1,0,0,0))
  #@bookmarks_by_month = @bookmarks.group_by(&:month)
  haml :year, :layout => :print
end

# models

class Bookmark < Sequel::Model

end
# migrations
#
migration "create books" do
  database.create_table :bookmarks do
    primary_key :id
    string   :href
    string   :description
    string   :extended
    string   :bookmark_hash
    string   :meta
    datetime :bookmarked_at
    string   :raw_tags
    timestamp :created_at
  end
end

migration "create tags and taggings" do
  database.create_table :tags do
    string :name
  end

  database.create_table :taggings do
    integer  "tag_id"
    integer  "taggable_id"
    string   "taggable_type"
    integer  "tagger_id"
    string   "tagger_type"
    string   "context",       :limit => 128
    datetime "created_at"

    index :tag_id
    index ["taggable_id", "taggable_type", "context"]
  end
end
