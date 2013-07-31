class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :receiver_id
      t.integer :sender_id
      t.boolean :is_read

      t.timestamps
    end
    add_index :messages, :receiver_id
    add_index :messages, :sender_id
  end
end
