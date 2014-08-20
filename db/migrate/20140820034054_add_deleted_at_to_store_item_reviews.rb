class AddDeletedAtToStoreItemReviews < ActiveRecord::Migration
  def change
    add_column :store_item_reviews, :deleted_at, :datetime
    add_index :store_item_reviews, :deleted_at
  end
end
