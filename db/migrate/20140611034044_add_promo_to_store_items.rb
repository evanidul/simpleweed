class AddPromoToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :promo, :text
  end
end
