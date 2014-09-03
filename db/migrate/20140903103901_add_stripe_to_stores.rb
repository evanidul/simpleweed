class AddStripeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :stripe_customer_id, :integer
    add_column :stores, :plan_id, :integer
  end
end
