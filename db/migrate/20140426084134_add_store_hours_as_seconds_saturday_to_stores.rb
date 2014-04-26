class AddStoreHoursAsSecondsSaturdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourssaturdayopen, :integer
    add_column :stores, :storehourssaturdayclosed, :integer
  end
end
