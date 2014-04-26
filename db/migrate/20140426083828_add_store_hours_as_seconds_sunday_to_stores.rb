class AddStoreHoursAsSecondsSundayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourssundayopen, :integer
    add_column :stores, :storehourssundayclosed, :integer
  end
end
