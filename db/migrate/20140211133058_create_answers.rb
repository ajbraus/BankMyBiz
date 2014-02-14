class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.references :user
      t.references :post
      t.boolean :accepted

      t.timestamps
    end
    add_index :answers, :user_id
    add_index :answers, :post_id
  end
end
