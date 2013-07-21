class CreateEmployeeSizes < ActiveRecord::Migration
  def change
    create_table :employee_sizes do |t|
      t.string :description

      t.timestamps
    end
    EmployeeSize.create(description: "0-6")
    EmployeeSize.create(description: "7-24")
    EmployeeSize.create(description: "25-99")
    EmployeeSize.create(description: "500-999")
    EmployeeSize.create(description: "999-2999")
    EmployeeSize.create(description: "3000+")
  end
end

    # PropertyType.create(id: 1, name: "size_employee")
    # PropertyType.create(id: 2, name: "size_revenue")
    # PropertyType.create(id: 3, name: "business_type")
    # PropertyType.create(id: 4, name: "industry")
    # PropertyType.create(id: 5, name: "years_old")

    # # #size_employee


    # # #size_revenue
    # PropertyType.find(2).create_property(description: "$0-$100k")    
    # PropertyType.find(2).create_property(description: "$100k-$1m")    
    # PropertyType.find(2).create_property(description: "$1m-$5m")    
    # PropertyType.find(2).create_property(description: "$5m-10m")    
    # PropertyType.find(2).create_property(description: "$10M and Above")    

    # # #business_type
    # PropertyType.find(3).create_property(description: "LLC")    
    # PropertyType.find(3).create_property(description: "C-Corp")    
    # PropertyType.find(3).create_property(description: "SP")    
    # PropertyType.find(3).create_property(description: "Partnership")    
    # PropertyType.find(3).create_property(description: "LLP")    
    # PropertyType.find(3).create_property(description: "Non-Stock")    

    # # #industry
    # PropertyType.find(4).create_property(description: "Service")    
    # PropertyType.find(4).create_property(description: "Retail")    
    # PropertyType.find(4).create_property(description: "Manufacturing")    
    # PropertyType.find(4).create_property(description: "Distribution")    
    # PropertyType.find(4).create_property(description: "Construction")    
    # PropertyType.find(4).create_property(description: "Restaurant")    
    # PropertyType.find(4).create_property(description: "Consulting")    
    # PropertyType.find(4).create_property(description: "Entertainment")    
    # PropertyType.find(4).create_property(description: "CRE")    
    # PropertyType.find(4).create_property(description: "Residential Real Estate")    
    # PropertyType.find(4).create_property(description: "Nonprofit")    
    # PropertyType.find(4).create_property(description: "Healthcare")    
    # PropertyType.find(4).create_property(description: "IT")
    # PropertyType.find(4).create_property(description: "Startup")
    # PropertyType.find(4).create_property(description: "Other")    

    # # #years_old
    # PropertyType.find(5).create_property(description: "0-1")    
    # PropertyType.find(5).create_property(description: "2-5")    
    # PropertyType.find(5).create_property(description: "5+")  