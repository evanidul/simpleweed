class FeedPostsController < ApplicationController

	before_filter :load_feed

	def new
		render layout: false		
	end

	def create		
		if current_user.nil?		
			return render 'login'
		end

		@feed_post =  @feed.feed_posts.create(feed_post_params)		
		@feed_post.user = current_user

		# need to verify that it has at least :post or :link set.  maybe check at model layer
		@feed_post.save		
		redirect_to feed_path(@feed.id)
	end

	def show

	end

	# show modal for adding flag reason
	def add_flag
		render layout: false
	end

	# process the flag add post from add_flag
	def flag
		postparams = params[:flag].permit(:reason)
		
		current_user.flag!(@post, postparams[:reason] )

		respond_to do |format|			
			return format.js {}
		end
	end

	private 
	def feed_post_params
		params.require(:feed_post).permit(:title, :post, :link)		
	end		

	private
    def load_feed
      @feed = Feed.find(params[:feed_id])
      if params[:id]
      	@post = FeedPost.find(params[:id])
      end
    end

end
