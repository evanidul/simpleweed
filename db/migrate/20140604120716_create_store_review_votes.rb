class CreateStoreReviewVotes < ActiveRecord::Migration
  def change
    create_table :store_review_votes do |t|
      t.references :store_review, index: true
      t.references :user, index: true
      t.integer :vote

      t.timestamps
    end
  end
end
