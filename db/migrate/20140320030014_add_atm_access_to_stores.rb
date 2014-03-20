class AddAtmAccessToStores < ActiveRecord::Migration
  def change
    add_column :stores, :atmaccess, :boolean
  end
end
