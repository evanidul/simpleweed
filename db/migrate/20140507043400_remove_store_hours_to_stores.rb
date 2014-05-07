class RemoveStoreHoursToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehourssunday, :string
    remove_column :stores, :storehoursmonday, :string
    remove_column :stores, :storehourstuesday, :string
    remove_column :stores, :storehourswednesday, :string
  end
end
