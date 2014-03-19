class AddDailySpecialsThursdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialsthursday, :string
  end
end
