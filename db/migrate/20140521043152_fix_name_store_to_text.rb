class FixNameStoreToText < ActiveRecord::Migration
  def change
  	change_column :stores, :name, :text
  end
end
