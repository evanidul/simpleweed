class AddPromoToStores < ActiveRecord::Migration
  def change
    add_column :stores, :promo, :text
  end
end
