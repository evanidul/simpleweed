class AddStoreHoursAsSecondsTuesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourstuesdayopen, :integer
    add_column :stores, :storehourstuesdayclosed, :integer
  end
end
