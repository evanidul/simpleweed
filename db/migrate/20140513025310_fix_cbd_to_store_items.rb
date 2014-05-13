class FixCbdToStoreItems < ActiveRecord::Migration
  def change
  	change_column :store_items, :cbd, :float
  end
end
