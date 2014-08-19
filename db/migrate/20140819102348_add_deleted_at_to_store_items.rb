class AddDeletedAtToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :deleted_at, :datetime
    add_index :store_items, :deleted_at
  end
end
