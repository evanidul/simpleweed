class FeedPostComment < ActiveRecord::Base
  belongs_to :feed_post
  belongs_to :user
end
