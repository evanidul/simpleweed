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

			if @store_review_comment.save
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
