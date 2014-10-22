class FeedPost < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  belongs_to :feed
  belongs_to :user

  has_many :feed_post_comments, :dependent => :destroy
  has_many :feed_post_votes, :dependent => :destroy
  
  validates :user, presence: true

  # posts may be flagged
  make_flaggable

  def sum_votes
    feed_post_votes.sum(:vote)
  end  	

  def should_generate_new_friendly_id?
    new_record?
  end

end
