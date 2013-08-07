class AddUserIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer

    Comment.all.each do |c|
      c.user = User.first
      c.save
    end
  end
end
