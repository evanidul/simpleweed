class FixThcToStoreItems < ActiveRecord::Migration
  def change
  	change_column :store_items, :thc, :float
  end
end
