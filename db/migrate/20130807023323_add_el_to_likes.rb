class AddElToLikes < ActiveRecord::Migration
  def change
    add_index :likes, :likeable_id
    add_column :likes, :user_id, :integer
  end
end
