class AddMiscAttrToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :privatereserve, :boolean
    add_column :store_items, :topshelf, :boolean
    add_column :store_items, :supersize, :boolean
    add_column :store_items, :glutenfree, :boolean
    add_column :store_items, :sugarfree, :boolean
  end
end
