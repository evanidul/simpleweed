class AddOrganitToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :organic, :boolean
  end
end
