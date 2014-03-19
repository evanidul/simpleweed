class AddDailySpecialsSundayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialssunday, :string
  end
end
