class AddDeletedAtToStoreItemReviewVotes < ActiveRecord::Migration
  def change
    add_column :store_item_review_votes, :deleted_at, :datetime
    add_index :store_item_review_votes, :deleted_at
  end
end
