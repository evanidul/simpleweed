class AddStarsToStoreItemReviews < ActiveRecord::Migration
  def change
    add_column :store_item_reviews, :stars, :integer
  end
end
