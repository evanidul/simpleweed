class AddStarsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :stars, :decimal
  end
end
