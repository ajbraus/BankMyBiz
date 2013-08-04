class RemoveUserDefaultBank < ActiveRecord::Migration
  def change
    change_column_default(:users, :bank, nil)
  end
end
