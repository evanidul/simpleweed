class RemoveVotesToStoreReviews < ActiveRecord::Migration
  def change
    remove_column :store_reviews, :up_votes, :integer
    remove_column :store_reviews, :down_votes, :integer
  end
end
