class FixAddPricePerUnitToStoreItems < ActiveRecord::Migration
  def change
  	rename_column :store_items, :priceperunit,  :costperunit  	
  end
end
