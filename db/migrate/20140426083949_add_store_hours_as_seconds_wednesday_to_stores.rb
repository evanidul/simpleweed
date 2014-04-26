class AddStoreHoursAsSecondsWednesdayToStores < ActiveRecord::Migration
  def change
    add_column :stores, :storehourswednesdayopen, :integer
    add_column :stores, :storehourswednesdayclosed, :integer
  end
end
