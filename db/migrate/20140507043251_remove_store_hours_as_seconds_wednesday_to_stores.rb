class RemoveStoreHoursAsSecondsWednesdayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehourswednesdayopen, :integer
    remove_column :stores, :storehourswednesdayclosed, :integer
  end
end
