class AddLastTouchedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_touched_at, :datetime, null:false, default: Time.now
  end
end
