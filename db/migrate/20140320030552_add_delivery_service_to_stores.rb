class AddDeliveryServiceToStores < ActiveRecord::Migration
  def change
    add_column :stores, :deliveryservice, :boolean
  end
end
