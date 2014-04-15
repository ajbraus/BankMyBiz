class CreateLoanPurposes < ActiveRecord::Migration
  def change
    create_table :loan_purposes do |t|
      t.string :description

      t.timestamps
    end

    LoanPurpose.create(description:"Expansion")
    LoanPurpose.create(description:"Buyout A Partner")
    LoanPurpose.create(description:"Marketing/Advertising")
    LoanPurpose.create(description:"Starting a Business")
    LoanPurpose.create(description:"Working Capital")
    LoanPurpose.create(description:"Refinance / Consolidate Debt")
    LoanPurpose.create(description:"Remodel an existing location")
    LoanPurpose.create(description:"Purchase Equipment")
    LoanPurpose.create(description:"Repair Equipment")
    LoanPurpose.create(description:"Other")
  end
end
