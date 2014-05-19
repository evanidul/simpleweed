class AddCultivationToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :cultivation, :string
  end
end
