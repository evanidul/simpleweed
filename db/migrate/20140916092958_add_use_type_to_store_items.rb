class AddUseTypeToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :usetype, :string
  end
end
