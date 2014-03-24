class AddIndexToProviderOnAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, :provider
  end
end
