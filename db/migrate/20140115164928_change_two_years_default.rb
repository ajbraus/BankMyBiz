class ChangeTwoYearsDefault < ActiveRecord::Migration
  def change
    change_column :users, :two_years, :boolean, default: nil
  end
end
