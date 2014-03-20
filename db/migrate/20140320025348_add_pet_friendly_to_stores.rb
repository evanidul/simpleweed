class AddPetFriendlyToStores < ActiveRecord::Migration
  def change
    add_column :stores, :petfriendly, :boolean
  end
end
