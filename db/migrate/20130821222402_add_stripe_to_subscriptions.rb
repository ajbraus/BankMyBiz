class AddStripeToSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :plan_id
      t.string :stripe_customer_token
    end
  end
end
