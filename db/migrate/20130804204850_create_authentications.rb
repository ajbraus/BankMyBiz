class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :authentications, :user_id
    add_index :authentications, :uid

    add_column :users, :pic_url, :string
    add_column :users, :linked_in_url, :string
    add_column :users, :location, :string
    add_column :users, :terms, :boolean, default: false
  end
end
