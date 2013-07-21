class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :description

      t.timestamps
    end
    Industry.create(description: "Service")    
    Industry.create(description: "Retail")    
    Industry.create(description: "Manufacturing")    
    Industry.create(description: "Distribution")    
    Industry.create(description: "Construction")    
    Industry.create(description: "Restaurant")    
    Industry.create(description: "Consulting")    
    Industry.create(description: "Entertainment")    
    Industry.create(description: "CRE")    
    Industry.create(description: "Residential Real Estate")    
    Industry.create(description: "Nonprofit")    
    Industry.create(description: "Healthcare")    
    Industry.create(description: "IT")
    Industry.create(description: "Startup")
    Industry.create(description: "Other") 
  end
end 
