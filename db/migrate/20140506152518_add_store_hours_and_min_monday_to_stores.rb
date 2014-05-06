class AddStoreHoursAndMinMondayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursmondayopenhour, :integer
    add_column :stores, :storehoursmondayopenminute, :integer
    add_column :stores, :storehoursmondayclosehour, :integer
    add_column :stores, :storehoursmondaycloseminute, :integer
  end
end
