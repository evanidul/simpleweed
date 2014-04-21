class AddCategoryToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :category, :string
  end
end
