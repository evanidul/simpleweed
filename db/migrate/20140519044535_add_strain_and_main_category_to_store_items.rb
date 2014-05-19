class AddStrainAndMainCategoryToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :maincategory, :string
    add_column :store_items, :strain, :string
  end
end
