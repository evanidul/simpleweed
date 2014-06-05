class StoreReviewVote < ActiveRecord::Base
  belongs_to :store_review
  belongs_to :user

  validates_inclusion_of :vote, :in => [1,-1]
  validates :store_review, :user, presence: true

  validates :store_review_id, uniqueness: {scope: :user_id}  #does not allow user to vote for the same post twice

  validate :users_cant_vote_their_reviews

  def users_cant_vote_their_reviews
	  return if user.nil? or store_review.nil?
	  if user_id == store_review.user.id
	    errors[:base] = "A user can't vote on their own reviews"
	  end
  end
end
