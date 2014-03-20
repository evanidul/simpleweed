class AddSecurityGuardToStores < ActiveRecord::Migration
  def change
    add_column :stores, :securityguard, :boolean
  end
end
