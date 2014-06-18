class StoreItemReviewCommentsController < ApplicationController

	before_filter :load_store_item_review

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
		
			@store_item_review_comment =  @store_item_review.store_item_review_comments.create(store_item_review_comments_params)		
			@store_item_review_comment.user = current_user

			if @store_item_review.store_item.store.email == @store_item_review_comment.user.email
				@storeowner = true
			else
				@storeowner = false
			end

			if @store_item_review_comment.save
				return format.js {}
			else
				messagearray = @store_item_review_comment.errors.full_messages	
				@message = messagearray
				return render 'commentsaveerror' 
			end

		end #respond_to

	end	


	private
    def load_store_item_review
      @store_item_review = StoreItemReview.find(params[:store_item_review_id])
    end

	private 
	def store_item_review_comments_params
		params.require(:store_item_review_comment).permit(:store_item_review_id, :user_id, :comment)		
	end		

end
