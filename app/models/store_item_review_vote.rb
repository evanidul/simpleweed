class StoreItemReviewVote < ActiveRecord::Base
  belongs_to :store_item_review
  belongs_to :user

  # enables soft delete
  acts_as_paranoid

  validates_inclusion_of :vote, :in => [1,-1]
  validates :store_item_review, :user, presence: true

  validates :store_item_review_id, uniqueness: {scope: :user_id}  #does not allow user to vote for the same post twice

  validate :users_cant_vote_their_reviews

  def users_cant_vote_their_reviews
	  return if user.nil? or store_item_review.nil?
	  if user_id == store_item_review.user.id
	    errors[:base] = "A user can't vote on their own reviews"
	  end
  end
end
