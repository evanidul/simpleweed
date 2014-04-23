class AddAddressLine2ToStores < ActiveRecord::Migration
  def change
    add_column :stores, :addressline2, :string
  end
end
