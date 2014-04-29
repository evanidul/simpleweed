class AddEmailToStores < ActiveRecord::Migration
  def change
    add_column :stores, :email, :string
  end
end
