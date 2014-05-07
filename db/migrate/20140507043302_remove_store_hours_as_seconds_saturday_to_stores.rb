class RemoveStoreHoursAsSecondsSaturdayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehourssaturdayopen, :integer
    remove_column :stores, :storehourssaturdayclosed, :integer
  end
end
