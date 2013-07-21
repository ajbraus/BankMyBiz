class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :description

      t.timestamps
    end
    BusinessType.create(description: "LLC")    
    BusinessType.create(description: "C-Corp")    
    BusinessType.create(description: "SP")    
    BusinessType.create(description: "Partnership")    
    BusinessType.create(description: "LLP")    
    BusinessType.create(description: "Non-Stock") 
  end
end
