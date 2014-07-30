class AddImageUrlToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :image_url, :string
  end
end
