class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :user
      t.integer :match_count
      t.integer :price
      t.string :coupon_code

      t.timestamps
    end
    add_index :purchases, :user_id
  end
end
