require 'spec_helper'

describe StoreItemReviewVotesController do
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
  			xhr :post, :create, store_id: @store.id, store_item_id: @item.id, store_item_review_id: @item_review.id, store_item_review_vote: attributes_for(:store_item_review_vote)
  			expect(response).to render_template :login
  		end  	
  	end

end
