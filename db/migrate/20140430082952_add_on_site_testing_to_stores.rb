class AddOnSiteTestingToStores < ActiveRecord::Migration
  def change
    add_column :stores, :onsitetesting, :boolean
  end
end
