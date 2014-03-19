class AddDailySpecialsTuesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialstuesday, :string
  end
end
