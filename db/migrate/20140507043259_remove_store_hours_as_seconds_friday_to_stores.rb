class RemoveStoreHoursAsSecondsFridayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehoursfridayopen, :integer
    remove_column :stores, :storehoursfridayclosed, :integer
  end
end
