class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :user
      t.string :stripe_card_token
      t.string :card_type
      t.string :last_four

      t.timestamps
    end
    add_index :cards, :user_id
  end
end
