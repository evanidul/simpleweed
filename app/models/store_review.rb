class StoreReview < ActiveRecord::Base
  belongs_to :store
  belongs_to :user

  has_many :store_review_votes

  validates :review, :stars, :user, :store, presence: true
  validates_inclusion_of :stars, :in => 1..5

  # from http://stackoverflow.com/questions/16919647/rails-how-to-restrict-user-from-entering-more-than-one-record-per-association
  # users may only write one review per store  
  
  validates :user_id, :uniqueness => { :scope => :store_id,
    :message => "Users may only write one review per store." }

  	

end
