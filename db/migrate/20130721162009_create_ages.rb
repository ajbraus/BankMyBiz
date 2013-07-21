class CreateAges < ActiveRecord::Migration
  def change
    create_table :ages do |t|
      t.string :description

      t.timestamps
    end
    Age.create(description: "0-1")    
    Age.create(description: "2-5")    
    Age.create(description: "5+")  
  end
end
