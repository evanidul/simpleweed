class AddStoreHoursAndMinSaturdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourssaturdayopenhour, :integer
    add_column :stores, :storehourssaturdayopenminute, :integer
    add_column :stores, :storehourssaturdayclosehour, :integer
    add_column :stores, :storehourssaturdaycloseminute, :integer
  end
end
