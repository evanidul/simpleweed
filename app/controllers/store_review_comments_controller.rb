class StoreReviewCommentsController < ApplicationController

	before_filter :load_store_review

	def login
		respond_to do |format|
			format.js {}
		end
	end

	def commentsaveerror
		respond_to do |format|
			format.js {}
		end
	end

	def create
		if current_user.nil?		
			return render 'login'
		end

		respond_to do |format|
		
			@store_review_comment =  @storereview.store_review_comments.create(store_review_comments_params)		
			@store_review_comment.user = current_user

			if @storereview.store.email == @store_review_comment.user.email
				@storeowner = true
			else
				@storeowner = false
			end

			if @store_review_comment.save
				# if a user comments on a review, they are immediately following that review so that they receive future comment alerts
				# on that review
				current_user.follow!(@storereview)

				# create a feed item for new comments
				@storereview.activity_params = {:store_review_comment_id => @store_review_comment.id}			
				@storereview.create_activity key: 'store_review.add_comment'

				return format.js {}
			else
				messagearray = @store_review_comment.errors.full_messages	
				@message = messagearray
				return render 'commentsaveerror' 
			end

		end #respond_to

	end	

	private
    def load_store_review
      @storereview = StoreReview.find(params[:store_review_id])
    end

	private 
	def store_review_comments_params
		params.require(:store_review_comment).permit(:store_review_id, :user_id, :comment)		
	end		

end
