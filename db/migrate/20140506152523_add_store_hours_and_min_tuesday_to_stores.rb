class AddStoreHoursAndMinTuesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourstuesdayopenhour, :integer
    add_column :stores, :storehourstuesdayopenminute, :integer
    add_column :stores, :storehourstuesdayclosehour, :integer
    add_column :stores, :storehourstuesdaycloseminute, :integer
  end
end
