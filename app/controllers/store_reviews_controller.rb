class StoreReviewsController < ApplicationController

	before_filter :load_store

	# dvu: do we need this?  Reviews being shown on the store page...not here really.
	def index
		@store_reviews = @store.store_reviews;		
	end

	# Require: Must be logged in
	# Require: Can only write one store review per user
	# Require: Storeowner/manager cannot review their own stores?
	def new
		if !authenticate_user!("You must be logged in to write a review.  Login now or sign up!", true) 
			return 
		end		
		@store_review = @store.store_reviews.build		
		render layout: false		
	end


	def create		
		if !authenticate_user!("You must be logged in to write a review.  Login now or sign up!", true) 
			return 
		end
		@store_review =  @store.store_reviews.create(store_review_params)		
		@store_review.user = current_user
		if @store_review.save
			flash[:notice] = "Thank you for submitting your review."
			redirect_to store_path(@store)
		else 
			messagearray = @store_review.errors.full_messages
			flash[:warning] = messagearray
			redirect_to store_path(@store)
		end
	end


private
    def load_store
      @store = Store.find(params[:store_id])
    end

private 
	def store_review_params
		params.require(:store_review).permit(:store_id, :user_id, :review, :stars)		
	end		

end
