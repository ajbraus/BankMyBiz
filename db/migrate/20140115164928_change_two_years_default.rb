class ChangeTwoYearsDefault < ActiveRecord::Migration
  def change
    change_column_default :users, :two_years, default: nil
  end
end
