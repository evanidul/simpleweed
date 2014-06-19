class StoreItemReviewsController < ApplicationController

	before_filter :load_store_item


	##### Creating a temporary way to write item reviews.  Need to look at these endpoints later when the 'real' way is done.


	# Require: Must be logged in
	# Require: Can only write one store review per user
	# Require: Storeowner/manager cannot review their own stores?
	def new
		if !authenticate_user!("You must be logged in to write a review.  Login now or sign up!", true) 
			return 
		end		
		#@store_item_review = @store_item.store_item_reviews.build		
		render layout: false		
	end


	def create		
		respond_to do |format|
			if !authenticate_user!("You must be logged in to write a review.  Login now or sign up!", true) 
				return 
			end
			@store_item_review =  @store_item.store_item_reviews.create(store_item_review_params)		
			@store_item_review.user = current_user
			@store = @store_item.store

			if @store_item_review.save
				# flash[:notice] = "Thank you for submitting your review."
				# redirect_to store_path(@store_item.store)
				return format.js {}
			else 
				messagearray = @store_item_review.errors.full_messages
				flash[:warning] = messagearray
				redirect_to store_path(@store_item.store)
			end
		end # respond_to
	end

	

	private
	    def load_store_item
	      @store_item = StoreItem.find(params[:store_item_id])	      
	    end

	private 
	def store_item_review_params
		params.require(:store_item_review).permit(:store_item_id, :user_id, :review, :stars)		
	end		

end
