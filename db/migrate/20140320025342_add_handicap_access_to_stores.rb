class AddHandicapAccessToStores < ActiveRecord::Migration
  def change
    add_column :stores, :handicapaccess, :boolean
  end
end
