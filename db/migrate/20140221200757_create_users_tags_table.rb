class CreateUsersTagsTable < ActiveRecord::Migration
  def self.up
    create_table :tags_users, :id => false do |t|
        t.references :user
        t.references :tag
    end
    add_index :tags_users, [:user_id, :tag_id]
    add_index :tags_users, [:tag_id, :user_id]

    User.all.each do |u|
      u.posts.each do |p|
        u.tags << p.tags
      end
    end
  end

  def self.down
    drop_table :tags_users
  end
end
