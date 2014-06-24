class StoreReviewComment < ActiveRecord::Base
  include PublicActivity::Model
  tracked :owner => :user
  
  belongs_to :store_review
  belongs_to :user

  validates :store_review, :user, presence: true
end
