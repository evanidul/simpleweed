class RemoveStoreHoursAsSecondsThursdayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehoursthursdayopen, :integer
    remove_column :stores, :storehoursthursdayclosed, :integer
  end
end
