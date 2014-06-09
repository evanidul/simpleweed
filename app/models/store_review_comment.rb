class StoreReviewComment < ActiveRecord::Base
  belongs_to :store_review
  belongs_to :user

  validates :store_review, :user, presence: true
end
