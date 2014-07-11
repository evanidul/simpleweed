class FeedPostCommentsController < ApplicationController

	before_filter :load_feed_post

	def create
		if current_user.nil?		
			return render 'login'
		end

		respond_to do |format|
		
			@feed_post_comment =  @feed_post.feed_post_comments.create(feed_post_comments_params)		
			@feed_post_comment.user = current_user

			
			if @feed_post_comment.save
			
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
