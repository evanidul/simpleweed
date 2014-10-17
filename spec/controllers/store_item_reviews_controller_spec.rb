require 'spec_helper'

describe StoreItemReviewsController do

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

  	describe 'new' do
  		it 'requires login' do
  			get :new, store_id: @store.id, store_item_id: @item.id
			expect(response).to render_template "modals/login"
  		end
  	end

  	describe 'create' do
  		it 'requires login' do
  			post :create, store_id: @store.id, store_item_id: @item.id, store_item_review: attributes_for(:store_item_review)
  			expect(response).to render_template "modals/login"
  		end
  		it 'doesnt allow store owners or managers to review' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			post :create, store_id: @store.id, store_item_id: @item.id, store_item_review: attributes_for(:store_item_review)
			expect(response).to redirect_to store_path(@store)
			expect(request.flash[:warning]).to eq("Store owners and managers cannot write reviews")
  		end
  		it 'doesnt allow users to review more than once (protected at model tier)' do
  		end

  	end #create

end
