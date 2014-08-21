class AddStarsToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :stars, :decimal
  end
end
