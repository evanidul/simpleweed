class AddStoreHoursAsSecondsMondayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursmondayopen, :integer
    add_column :stores, :storehoursmondayclosed, :integer
  end
end
