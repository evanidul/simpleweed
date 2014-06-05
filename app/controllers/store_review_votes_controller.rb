class StoreReviewVotesController < ApplicationController

before_filter :load_store_review

	def login
		respond_to do |format|
			format.js {}
		end
	end

	def create		
		
		if current_user.nil?
			#format.js { file 'login' }
			render 'login'
		end

		respond_to do |format|
		
		@store_review_vote =  @storereview.store_review_votes.create(store_review_votes_params)		
		@store_review_vote.user = current_user

		
      		#format.html # new.html.erb
      		#format.json { render json: @store_review_vote }
      		format.js

      		@vote = store_review_votes_params[:vote];
      		


			if @store_review_vote.save

				#@currentcount = @storereview.store_review_votes.sum(:vote)
				@currentcount = @storereview.sum_votes

				format.js {}
			else 
				return
			end
		end # respond_to
	end

private
    def load_store_review
      @storereview = StoreReview.find(params[:store_review_id])
    end

private 
	def store_review_votes_params
		params.require(:store_review_vote).permit(:store_review_id, :user_id, :vote)		
	end		

end
