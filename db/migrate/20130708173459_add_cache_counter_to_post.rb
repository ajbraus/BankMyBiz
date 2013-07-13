class AddCacheCounterToPost < ActiveRecord::Migration
  def change
    add_column :users, :impressions_count, :integer, default: 0
  end
end
