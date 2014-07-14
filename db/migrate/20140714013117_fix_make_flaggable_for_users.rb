class FixMakeFlaggableForUsers < ActiveRecord::Migration
  def change
  	add_column :users, :flaggings_count, :integer  	
  end
end
