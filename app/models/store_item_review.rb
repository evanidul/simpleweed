class StoreItemReview < ActiveRecord::Base

  include PublicActivity::Model
  tracked

  belongs_to :store_item
  belongs_to :user

  has_many :store_item_review_votes
  has_many :store_item_review_comments

  validates :review, :stars, :user, :store_item, presence: true
  validates_inclusion_of :stars, :in => 1..5

  validates :user_id, :uniqueness => { :scope => :store_item_id,
    :message => "Users may only write one review per item." }

  def sum_votes
    store_item_review_votes.sum(:vote)
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
