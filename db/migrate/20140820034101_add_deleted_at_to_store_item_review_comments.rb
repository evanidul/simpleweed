class AddDeletedAtToStoreItemReviewComments < ActiveRecord::Migration
  def change
    add_column :store_item_review_comments, :deleted_at, :datetime
    add_index :store_item_review_comments, :deleted_at
  end
end
