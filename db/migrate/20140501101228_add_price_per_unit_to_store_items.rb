class AddPricePerUnitToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :priceperunit, :integer
  end
end
