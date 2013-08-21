class AddPositionOrgNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :org_name, :string
    add_column :users, :position, :string
  end
end
