require 'spec_helper'

describe StoreReviewVotesController do
	include Devise::TestHelpers

	
  	before(:each) do
  		@store = create(:store)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

  	before(:each) do
  		@store_review = create(:store_review, :store => @store, :user => @user)
  	end

  	# anyone who's logged in can comment, including owners and admins.
  	describe 'create' do
  		it 'requires login' do
  			xhr :post, :create, store_id: @store.id, store_review_id: @store_review.id, store_review_vote: attributes_for(:store_review_vote)
			expect(response).to render_template :login
  		end
  	end

end
