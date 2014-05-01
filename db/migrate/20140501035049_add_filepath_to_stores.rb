class AddFilepathToStores < ActiveRecord::Migration
  def change
    add_column :stores, :filepath, :string
  end
end
