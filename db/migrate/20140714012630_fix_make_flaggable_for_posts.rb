class FixMakeFlaggableForPosts < ActiveRecord::Migration
  def change
	  add_column :feed_posts, :flaggings_count, :integer  	
  end
end
