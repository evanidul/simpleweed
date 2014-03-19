class AddDailySpecialsWednesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialswednesday, :string
  end
end
