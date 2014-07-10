class FeedPostsController < ApplicationController

	before_filter :load_feed

	def new
		render layout: false		
	end

	def create		
		@feed_post =  @feed.feed_posts.create(feed_post_params)		
		# need to verify that it has at least :post or :link set.  maybe check at model layer
		@feed_post.save		
		redirect_to feed_path(@feed.id)
	end

	private 
	def feed_post_params
		params.require(:feed_post).permit(:title, :post, :link)		
	end		

	private
    def load_feed
      @feed = Feed.find(params[:feed_id])
    end

end
