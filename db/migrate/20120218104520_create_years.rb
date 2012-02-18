class CreateYears < ActiveRecord::Migration
  def self.up
    create_table "years", :force => true do |t|
      t.string "year_string"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
    add_column :bookmarks, :year_id, :integer
  end

  def self.down
    remove_table :years
    remove_column :bookmarks, :year_id
  end
end
