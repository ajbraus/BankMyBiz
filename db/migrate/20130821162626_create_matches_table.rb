class CreateMatchesTable < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_id
      t.integer :match_id

      t.timestamps
    end
    add_index :matches, :user_id
    add_index :matches, :match_id
    add_index :matches, [:user_id, :match_id], unique: true
  end
end
