class AddAutomaticDispensingMachinesToStores < ActiveRecord::Migration
  def change
    add_column :stores, :automaticdispensingmachines, :boolean
  end
end
