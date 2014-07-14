class FixMakeFlaggableForStoreReviews < ActiveRecord::Migration
  def change
  	add_column :store_reviews, :flaggings_count, :integer  	
  end
end
