require 'spec_helper'

describe StoreItemReviewCommentsController do
	include Devise::TestHelpers

	
  	before(:each) do
  		@store = create(:store)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

  	before(:each) do
  		@item = create(:store_item, :store => @store)
  	end

  	before(:each) do  		
  		@item_review = create(:store_item_review, :store_item => @item, :user => @user)
  	end

  	describe 'create' do
  		it 'requires login' do
  			xhr :post, :create, store_id: @store.id, store_item_id: @item.id, store_item_review_id: @item_review.id, store_item_review_comment: attributes_for(:store_item_review_comment)
  			expect(response).to redirect_to new_user_session_url
  		end  	
  	end
end
