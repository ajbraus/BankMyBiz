class AddDeleteAndRejectedToUser < ActiveRecord::Migration
  def change
    add_column :users, :rejected_at, :datetime
    add_column :users, :deleted, :boolean, default: false
  end
end
