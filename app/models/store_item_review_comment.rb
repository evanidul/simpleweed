class StoreItemReviewComment < ActiveRecord::Base
  belongs_to :store_item_review
  belongs_to :user

  validates :store_item_review, :user, presence: true
end
