class AddStoreHoursAndMinThursdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursthursdayopenhour, :integer
    add_column :stores, :storehoursthursdayopenminute, :integer
    add_column :stores, :storehoursthursdayclosehour, :integer
    add_column :stores, :storehoursthursdaycloseminute, :integer
  end
end
