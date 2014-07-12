class FeedPostVote < ActiveRecord::Base
  belongs_to :feed_post
  belongs_to :user

  validates_inclusion_of :vote, :in => [1,-1]
  validates :feed_post, :user, presence: true

  validates :feed_post_id, uniqueness: {scope: :user_id}  #does not allow user to vote for the same post twice

  validate :users_cant_vote_their_posts

  def users_cant_vote_their_posts
	  return if user.nil? or feed_post.nil?
	  if user_id == feed_post.user.id
	    errors[:base] = "A user can't vote on their own posts"
	  end
  end

end
