class RemoveStoreHours2ToStores < ActiveRecord::Migration
  def change
    remove_column :stores, :storehoursthursday, :string
    remove_column :stores, :storehoursfriday, :string
    remove_column :stores, :storehourssaturday, :string
  end
end
