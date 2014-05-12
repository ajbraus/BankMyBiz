class AddPriceToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :price_in_cents, :integer, default: 0
    rename_column :subscriptions, :plan, :plan_id
    add_index :subscriptions, :plan_id
  end
end
