class FeedPostCommentsController < ApplicationController

	before_filter :load_feed_post

	def create
		if !authenticate_user!("You must be logged in to comment on a post.  Login now or sign up!") 
			return 
		end		

		respond_to do |format|
		
			@feed_post_comment =  @feed_post.feed_post_comments.create(feed_post_comments_params)		
			@feed_post_comment.user = current_user

			
			if @feed_post_comment.save

				if @feed_post_comment.user != @feed_post.user
					UserMailer.delay.user_commented_on_post(@feed_post_comment.user, @feed_post)
				end
			
				return format.js {}
			else
				messagearray = @feed_post_comment.errors.full_messages	
				@message = messagearray
				return render 'commentsaveerror' 
			end

		end #respond_to

	end	

	private
    def load_feed_post
      @feed_post = FeedPost.find(params[:feed_post_id])
    end

	private 
	def feed_post_comments_params
		params.require(:feed_post_comment).permit(:feed_post_id, :user_id, :comment)		
	end		


end
