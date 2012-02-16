class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table "bookmarks", :force => true do |t|
      t.string   "href"
      t.string   "description"
      t.string   "extended"
      t.string   "bookmark_hash"
      t.string   "meta"
      t.datetime "bookmarked_at"
      t.string   "raw_tags"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
  end

  def self.down
    remove_table "bookmarks"
  end
end
