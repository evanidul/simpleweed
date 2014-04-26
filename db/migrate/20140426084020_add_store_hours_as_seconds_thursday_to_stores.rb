class AddStoreHoursAsSecondsThursdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursthursdayopen, :integer
    add_column :stores, :storehoursthursdayclosed, :integer
  end
end
