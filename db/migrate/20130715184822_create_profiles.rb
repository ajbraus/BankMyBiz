class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :owner
      t.string :phone
      t.string :email
      t.string :city
      t.string :state
      t.string :bank_type
      t.string :business_type
      t.text :industries
      t.string :years_old
      t.string :size_cash
      t.string :size_employees
      t.boolean :existing_loans
      t.integer :owners_count
      t.text :bio
      t.references :user

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
