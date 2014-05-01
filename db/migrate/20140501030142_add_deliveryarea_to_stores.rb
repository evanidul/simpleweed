class AddDeliveryareaToStores < ActiveRecord::Migration
  def change
    add_column :stores, :deliveryarea, :text
  end
end
