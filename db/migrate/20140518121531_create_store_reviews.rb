class CreateStoreReviews < ActiveRecord::Migration
  def change
    create_table :store_reviews do |t|
      t.references :store, index: true
      t.references :user, index: true
      t.text :review
      t.integer :up_votes
      t.integer :down_votes

      t.timestamps
    end
  end
end
