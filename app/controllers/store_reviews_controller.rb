class StoreReviewsController < ApplicationController

	before_filter :load_store

	def index
		@store_reviews = @store.store_reviews;		
	end

	def new
		@store_review = @store.store_reviews.build
		render layout: false		
	end


	def create		
		@store_review =  @store.store_reviews.create(store_review_params)		
		@store_review.save
		redirect_to store_path(@store)
	end


private
    def load_store
      @store = Store.find(params[:store_id])
    end

private 
	def store_review_params
		params.require(:store_review).permit(:store_id, :user_id, :review)		
	end		

end
