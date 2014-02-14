class AddTitleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string, null: false, default: ""
    remove_column :posts, :bank

    Post.all.each do |p|
      p.update_attributes(title: p.content[0,155] + " ...")
    end
  end
end
