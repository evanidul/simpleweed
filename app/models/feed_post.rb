class FeedPost < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user

  has_many :feed_post_comments
  
  validates :user, presence: true
end
