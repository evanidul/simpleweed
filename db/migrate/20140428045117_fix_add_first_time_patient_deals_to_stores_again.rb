class FixAddFirstTimePatientDealsToStoresAgain < ActiveRecord::Migration
  def change
  	change_column :stores, :firsttimepatientdeals, :text
  end
end
