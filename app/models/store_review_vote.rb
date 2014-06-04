class StoreReviewVote < ActiveRecord::Base
  belongs_to :store_review
  belongs_to :user

  validates_inclusion_of :vote, :in => [1,-1]
  validates :store_review, :user, presence: true
end
