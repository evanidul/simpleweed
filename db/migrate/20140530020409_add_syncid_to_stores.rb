class AddSyncidToStores < ActiveRecord::Migration
  def change
    add_column :stores, :syncid, :integer
  end
end
