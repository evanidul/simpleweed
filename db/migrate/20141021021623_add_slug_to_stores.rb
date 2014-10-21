class AddSlugToStores < ActiveRecord::Migration
  def change
    add_column :stores, :slug, :string
    add_index :stores, :slug
  end
end
