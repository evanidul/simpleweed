class AddStoreHoursAsSecondsFridayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursfridayopen, :integer
    add_column :stores, :storehoursfridaydayclosed, :integer
  end
end
