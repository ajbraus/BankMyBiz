class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.integer :user_id
      t.integer :peer_id

      t.timestamps
    end
    add_index :peers, :user_id
    add_index :peers, :peer_id
    add_index :peers, [:user_id, :peer_id], unique: true
  end
end
