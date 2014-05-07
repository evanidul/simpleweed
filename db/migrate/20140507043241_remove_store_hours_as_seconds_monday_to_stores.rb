class RemoveStoreHoursAsSecondsMondayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehoursmondayopen, :integer
    remove_column :stores, :storehoursmondayclosed, :integer
  end
end
