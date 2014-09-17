class StoreReviewVote < ActiveRecord::Base
  belongs_to :store_review
  belongs_to :user

  validates_inclusion_of :vote, :in => [1,-1]
  validates :store_review, :user, presence: true

  validates :store_review_id, uniqueness: {scope: :user_id}  #does not allow user to vote for the same post twice

  validate :users_cant_vote_their_reviews
  validate :storeowner_and_manager_cannot_vote_on_review

  def users_cant_vote_their_reviews
	  return if user.nil? or store_review.nil?
	  if user_id == store_review.user.id
	    errors[:base] = "A user can't vote on their own reviews"
	  end
  end

  def storeowner_and_manager_cannot_vote_on_review
    return if user.nil?
    @role_service = Simpleweed::Security::Roleservice.new
    if @role_service.isStoreManager(user) || @role_service.isStoreOwner(user)
      errors[:base] = "Store owners and managers cannot vote on reviews"
    end
  end

end
