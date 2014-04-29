class AddWebsiteToStores < ActiveRecord::Migration
  def change
    add_column :stores, :website, :string
  end
end
