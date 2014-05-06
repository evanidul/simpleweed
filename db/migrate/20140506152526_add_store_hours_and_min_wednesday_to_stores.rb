class AddStoreHoursAndMinWednesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourswednesdayopenhour, :integer
    add_column :stores, :storehourswednesdayopenminute, :integer
    add_column :stores, :storehourswednesdayclosehour, :integer
    add_column :stores, :storehourswednesdaycloseminute, :integer
  end
end
