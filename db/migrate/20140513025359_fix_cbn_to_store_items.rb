class FixCbnToStoreItems < ActiveRecord::Migration
  def change
  	change_column :store_items, :cbn, :float
  end
end
