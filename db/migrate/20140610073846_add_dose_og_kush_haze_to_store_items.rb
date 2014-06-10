class AddDoseOgKushHazeToStoreItems < ActiveRecord::Migration
  def change
    add_column :store_items, :dose, :float
    add_column :store_items, :og, :boolean
    add_column :store_items, :kush, :boolean
    add_column :store_items, :haze, :boolean
  end
end
