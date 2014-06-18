class CreateStoreItemReviews < ActiveRecord::Migration
  def change
    create_table :store_item_reviews do |t|
      t.references :store_item, index: true
      t.references :user, index: true
      t.text :review

      t.timestamps
    end
  end
end
