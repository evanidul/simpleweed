class StoreReview < ActiveRecord::Base
  # store changes in activity feed
  include PublicActivity::Model
  tracked :owner => :user

  # when a user comments on a review, they follow that review
  acts_as_followable

  belongs_to :store
  belongs_to :user

  has_many :store_review_votes
  has_many :store_review_comments

  # store reviews may be flagged
  make_flaggable

  validates :review, :stars, :user, :store, presence: true
  validates_inclusion_of :stars, :in => 1..5

  # from http://stackoverflow.com/questions/16919647/rails-how-to-restrict-user-from-entering-more-than-one-record-per-association
  # users may only write one review per store  
  
  validates :user_id, :uniqueness => { :scope => :store_id,
    :message => "Users may only write one review per store." }

  def sum_votes
    store_review_votes.sum(:vote)
  end  	

  #dvu: this validation is untested by UI tests, b/c the view code already prevents this action.  Maybe write some model tests?
  validate :storeowner_and_manager_cannot_review

  def storeowner_and_manager_cannot_review
    return if user.nil?
    @role_service = Simpleweed::Security::Roleservice.new
    if @role_service.isStoreManager(user) || @role_service.isStoreOwner(user)
      errors[:base] = "Store owners and managers cannot write reviews"
    end
  end

end
