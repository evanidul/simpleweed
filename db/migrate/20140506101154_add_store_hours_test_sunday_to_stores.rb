class AddStoreHoursTestSundayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourssundayopenhour, :integer
    add_column :stores, :storehourssundayopenminute, :integer
    add_column :stores, :storehourssundayclosehour, :integer
    add_column :stores, :storehourssundaycloseminute, :integer
  end
end
