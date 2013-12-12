class CreateCustomerTypes < ActiveRecord::Migration
  def change
    create_table :customer_types do |t|
      t.string :description

      t.timestamps
    end
    CustomerType.create(description: "Business to Business")
    CustomerType.create(description: "Business to Consumer")
  end
end
