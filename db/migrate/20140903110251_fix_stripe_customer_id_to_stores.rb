class FixStripeCustomerIdToStores < ActiveRecord::Migration
  def change  	
  	change_column :stores, :stripe_customer_id, :string
  end
end
