class AddSyncidToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :syncid, :integer
  end
end
