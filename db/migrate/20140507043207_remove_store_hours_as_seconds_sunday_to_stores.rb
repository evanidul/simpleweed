class RemoveStoreHoursAsSecondsSundayToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehourssundayopen, :integer
    remove_column :stores, :storehourssundayclosed, :integer
  end
end
