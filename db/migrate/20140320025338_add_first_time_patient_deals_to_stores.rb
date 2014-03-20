class AddFirstTimePatientDealsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :firsttimepatientdeals, :boolean
  end
end
