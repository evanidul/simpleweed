class StoreReview < ActiveRecord::Base
  belongs_to :store
  belongs_to :user

  validates :review, :stars, presence: true
  validates_inclusion_of :stars, :in => 1..5
end
