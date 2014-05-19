class AddSubCategoryToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :subcategory, :string
  end
end
