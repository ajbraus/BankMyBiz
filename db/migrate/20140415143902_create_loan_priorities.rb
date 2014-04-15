class CreateLoanPriorities < ActiveRecord::Migration
  def change
    create_table :loan_priorities do |t|
      t.string :description

      t.timestamps
    end

    LoanPriority.create(description:"Lowest Rate")
    LoanPriority.create(description:"Simplest Documentation")
    LoanPriority.create(description:"Longest Repayment")
    LoanPriority.create(description:"Least Turn Around Time")
    LoanPriority.create(description:"Least Collateral")
  end
end
