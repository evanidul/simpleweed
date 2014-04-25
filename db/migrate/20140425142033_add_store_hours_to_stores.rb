class AddStoreHoursToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourssunday, :string
    add_column :stores, :storehoursmonday, :string
    add_column :stores, :storehourstuesday, :string
    add_column :stores, :storehourswednesday, :string
  end
end
