class StoreItemReviewComment < ActiveRecord::Base

  include PublicActivity::Model
  tracked :owner => :user
  belongs_to :store_item_review
  belongs_to :user

  validates :store_item_review, :user, presence: true
end
