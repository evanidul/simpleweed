class AddStoreHours2ToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehoursthursday, :string
    add_column :stores, :storehoursfriday, :string
    add_column :stores, :storehourssaturday, :string
  end
end
