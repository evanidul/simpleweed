class AddStoreHoursAndMinFridayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursfridayopenhour, :integer
    add_column :stores, :storehoursfridayopenminute, :integer
    add_column :stores, :storehoursfridayclosehour, :integer
    add_column :stores, :storehoursfridaycloseminute, :integer
  end
end
