class StoreReviewVotesController < ApplicationController

	before_filter :load_store_review

	# not actually used when render 'login' is called.  Render just accesses that view.
	def login
		respond_to do |format|
			format.js {}
		end
	end

	# not actually used when render 'votecannotbecast' is called.
	def votecannotbecast		
		respond_to do |format|
			format.js {}
		end
	end

	def create		
		# this breaks our pattern for auth check because it's an ajax request that returns javascript which will show the login
		# popup
		if current_user.nil?
			#format.js { file 'login' }			
			return render 'login'
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

				# update store stars
				@scoreservice = Simpleweed::Score::Scoreservice.new
				store = @store_review_vote.store_review.store
				score = @scoreservice.calculate_stars_for_store(store)
				store.stars = score
				store.save			

				return format.js {}
			else 
				messagearray = @store_review_vote.errors.full_messages

				if messagearray.include? "A user can't vote on their own reviews"
					@message = "A user can't vote on their own reviews"
					return render 'votecannotbecast' 
				end

				if messagearray.include? "Store review has already been taken"
					@message = 'You cannot cast more than 1 vote per review'
					return render 'votecannotbecast' 
				end

				if messagearray.include? "Store owners and managers cannot vote on reviews"
					@message = "Store owners and managers cannot vote on reviews"
					return render 'votecannotbecast'
				end
				
				@message = "Your vote could not be saved."
				return render 'votecannotbecast' 
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
