class FixAddStoreHoursAsSecondsFridayToStores < ActiveRecord::Migration
  def change
  	rename_column :stores, :storehoursfridaydayclosed,  :storehoursfridayclosed  	
  end
end
