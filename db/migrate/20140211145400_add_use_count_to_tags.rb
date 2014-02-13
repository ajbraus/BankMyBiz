class AddUseCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :use_count, :integer, null:false, default: 0

    Tag.all.each do |t|
      t.use_count = t.posts.count
      t.name.camelcase
      t.save
    end
  end
end
