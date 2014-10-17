require 'spec_helper'

describe StoreReviewCommentsController do
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
  			post :create, store_id: @store.id, store_review_id: @store_review.id, store_review_comment: attributes_for(:store_review_comment)
			  expect(response).to redirect_to new_user_session_url
  		end
  	end


end
