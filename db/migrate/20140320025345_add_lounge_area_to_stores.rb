class AddLoungeAreaToStores < ActiveRecord::Migration
  def change
    add_column :stores, :loungearea, :boolean
  end
end
