class AddStarsToStoreReviews < ActiveRecord::Migration
  def change
    add_column :store_reviews, :stars, :integer
  end
end
