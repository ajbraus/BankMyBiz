class AddCouponCodeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :coupon_code, :string
  end
end
