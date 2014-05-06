class AddStoreHoursClosedBooleansToStores < ActiveRecord::Migration
  def change
    add_column :stores, :sundayclosed, :boolean
    add_column :stores, :mondayclosed, :boolean
    add_column :stores, :tuesdayclosed, :boolean
    add_column :stores, :wednesdayclosed, :boolean
    add_column :stores, :thursdayclosed, :boolean
    add_column :stores, :fridayclosed, :boolean
    add_column :stores, :saturdayclosed, :boolean
  end
end
