class RemoveStoreHoursAsSecondsTuesdayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehourstuesdayopen, :integer
    remove_column :stores, :storehourstuesdayclosed, :integer
  end
end
