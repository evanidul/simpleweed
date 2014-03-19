class AddDailySpecialsSaturdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialssaturday, :string
  end
end
