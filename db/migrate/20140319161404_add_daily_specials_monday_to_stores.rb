class AddDailySpecialsMondayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :dailyspecialsmonday, :string
  end
end
