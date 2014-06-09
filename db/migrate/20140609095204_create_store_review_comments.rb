class CreateStoreReviewComments < ActiveRecord::Migration
  def change
    create_table :store_review_comments do |t|
      t.references :store_review, index: true
      t.references :user, index: true
      t.text :comment

      t.timestamps
    end
  end
end
