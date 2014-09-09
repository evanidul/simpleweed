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
		it "works if admin user is logged in and plan_id is 2 or greater" do						
			@store.plan_id = 3			
			@store.save															
			sign_in @admin			
			
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(@new_promo)
		end

		it "works if the user is a store manager and plan_id is 2 or greater" do
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

		it "requires login" do
			#sign_in user
    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.promo).to be_nil 
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}    		
    		expect(response).to render_template :error_authorization
    		expect(@store.promo).to be_nil     		
		end

		it "redirects to subscription page if plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_promo

	describe 'update_description' do
		it "works if admin logs in and plan_id is 2 or greater" do
			@store.plan_id = 2
			@store.save
			sign_in @admin
			
			@new_description = 'this store is awesome'
			put :update_description, id: @store.id, store: {description: @new_description}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.description).to eq(@new_description)
		end

		it "works if store owner logs in and plan_id is 2 or greater" do
			@store.plan_id = 2			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			@new_description = 'this store is awesome'
			put :update_description, id: @store.id, store: {description: @new_description}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.description).to eq(@new_description)
		end

		it "requires login" do
			#sign_in user
			@new_description = 'this store is awesome'
    		put :update_description, id: @store.id, store: {description: @new_description}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.description).to eq("none.")
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		put :update_description, id: @store.id, store: {description: @new_description}
    		expect(response).to render_template :error_authorization
    		expect(@store.description).to eq("none.")     		
		end

		it "redirects to subscription page if plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin

			@new_description = 'this store is awesome'
    		put :update_description, id: @store.id, store: {description: @new_description}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_description

	describe 'update_features' do
		it "works if admin logs in and plan_id is 2 or greater" do
			@store.plan_id = 3
			@store.save
			sign_in @admin
						
			put :update_features, id: @store.id, store: {acceptscreditcards: true, atmaccess: true}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.acceptscreditcards).to eq(true)
    		expect(@store.atmaccess).to eq(true)
		end

		it "works if store owner logs in and plan_id is 2 or greater" do
			@store.plan_id = 2			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			put :update_features, id: @store.id, store: {acceptscreditcards: true, atmaccess: true}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.acceptscreditcards).to eq(true)
    		expect(@store.atmaccess).to eq(true)
		end

		it "requires login" do
			#sign_in user
			put :update_features, id: @store.id, store: {acceptscreditcards: true, atmaccess: true}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.acceptscreditcards).to be_nil     		
    		expect(@store.atmaccess).to be_nil     		
		end		

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		put :update_features, id: @store.id, store: {acceptscreditcards: true, atmaccess: true}
    		expect(response).to render_template :error_authorization
    		expect(@store.acceptscreditcards).to be_nil     		
    		expect(@store.atmaccess).to be_nil     		
		end

		it "redirects to subscription page if plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin

			put :update_features, id: @store.id, store: {acceptscreditcards: true, atmaccess: true}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_features

end
