require 'spec_helper'

describe StoresController do
	include Devise::TestHelpers

	before(:each) do
		user = 'ddadmin'
		pw = 'idontreallysmoke'
		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)    	
  	end

  	before(:each) do
  		@store = create(:store)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

	describe 'GET #show' do
		it "shows a store page" do			
			get :show, id: @store.id
			expect(response).to render_template :show
		end
	end

	describe 'update_promo' do
		it "WORKING: update a store's promo works if admin user is logged in and plan_id is 2 or greater" do						
			@store.plan_id = 3			
			@store.save															
			sign_in @admin			
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(@new_promo)
		end

		it "WORKING: update a store's promo works if the user is a store manager and plan_id is 2 or greater" do
			@store.plan_id = 3			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(@new_promo)
		end

		it "update a store's promo requires login" do
			#sign_in user
    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.promo).to be_nil 
		end

		it "update a store's promo requires store manager role or admin, renders error when user not admin and store unclaimed" do			    		
			sign_in @user
    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}    		
    		expect(response).to render_template :error_authorization
    		expect(@store.promo).to be_nil     		
		end

		it "update a store's promo redirects to subscription page if admin user is logged in but plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_promo

	describe 'update_description' do
		it "WORKING: update description requires admin login and plan_id of 2 or greater" do
			@store.plan_id = 2
			@store.save
			sign_in @admin
			@new_description = 'this store is awesome'
			put :update_description, id: @store.id, store: {description: @new_description}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.description).to eq(@new_description)
		end
	end #update_description

end
