class AddDailySpecialsFridayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialsfriday, :string
  end
end
