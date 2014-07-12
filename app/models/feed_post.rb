class FeedPost < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user

  has_many :feed_post_comments
  has_many :feed_post_votes
  
  validates :user, presence: true

  def sum_votes
    feed_post_votes.sum(:vote)
  end  	

end
