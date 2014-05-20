class FixNameAndDescriptionStoreItemToText < ActiveRecord::Migration
  def change
  	change_column :store_items, :name, :text
  	change_column :store_items, :description, :text
  end
end
