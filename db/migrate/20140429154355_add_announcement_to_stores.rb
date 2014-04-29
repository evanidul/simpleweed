class AddAnnouncementToStores < ActiveRecord::Migration
  def change
    add_column :stores, :announcement, :text
  end
end
