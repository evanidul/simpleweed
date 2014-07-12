class FeedPostVotesController < ApplicationController

	before_filter :load_feed_post

	def login
		respond_to do |format|
			format.js {}
		end
	end

	def votecannotbecast		
		respond_to do |format|
			format.js {}
		end
	end

	def create		
		
		if current_user.nil?
			#format.js { file 'login' }
			return render 'login'
		end

		respond_to do |format|
		
			@feed_post_vote =  @feed_post.feed_post_votes.create(feed_post_votes_params)		
			@feed_post_vote.user = current_user

      		format.js

      		@vote = feed_post_votes_params[:vote];
      		
			if @feed_post_vote.save
				
				@currentcount = @feed_post.sum_votes

				return format.js {}
			else 
				messagearray = @feed_post_vote.errors.full_messages

				if messagearray.include? "A user can't vote on their own posts"
					@message = "A user can't vote on their own posts"
					return render 'votecannotbecast' 
				end

				if messagearray.include? "Feed post has already been taken"
					@message = 'You cannot cast more than 1 vote per post'
					return render 'votecannotbecast' 
				end
				
				@message = "Your vote could not be saved."
				return render 'votecannotbecast' 
			end
		end # respond_to
	end

	private
    def load_feed_post
      @feed_post = FeedPost.find(params[:feed_post_id])
    end

    private 
	def feed_post_votes_params
		params.require(:feed_post_vote).permit(:feed_post_id, :user_id, :vote)		
	end		


end
