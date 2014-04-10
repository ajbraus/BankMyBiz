class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.references :funder
      t.references :owner
      t.string :products
      t.string :purpose
      t.text :details
      t.string :size, null: false

      t.timestamps
    end
  end
end
