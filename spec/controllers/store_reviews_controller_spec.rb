require 'spec_helper'

describe StoreReviewsController do
	include Devise::TestHelpers

	
  	before(:each) do
  		@store = create(:store)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

  	describe 'new' do
  		it 'requires login' do
  			get :new, store_id: @store.id
			expect(response).to render_template "modals/login"
  		end
  	end

  	describe 'create' do
  		it 'requires login' do
  			post :create, store_id: @store.id, store_review: attributes_for(:store_review)
  			expect(response).to render_template "modals/login"
  		end
  		it 'doesnt allow store owners or managers to review' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			post :create, store_id: @store.id, store_review: attributes_for(:store_review)
			expect(response).to render_template :error_authorization
  		end
  		it 'doesnt allow users to review more than once (protected at model tier)' do
  		end

  	end #create

end
