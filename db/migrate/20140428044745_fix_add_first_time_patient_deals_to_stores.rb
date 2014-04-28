class FixAddFirstTimePatientDealsToStores < ActiveRecord::Migration
  def change
  	change_column :stores, :firsttimepatientdeals, :string
  end
end
