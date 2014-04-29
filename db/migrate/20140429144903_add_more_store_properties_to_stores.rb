class AddMoreStorePropertiesToStores < ActiveRecord::Migration
  def change
    add_column :stores, :eighteenplus, :boolean
    add_column :stores, :twentyoneplus, :boolean
    add_column :stores, :labtested, :boolean
    add_column :stores, :hasphotos, :boolean
  end
end
