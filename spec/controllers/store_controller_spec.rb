require 'spec_helper'

describe StoresController do
	include Devise::TestHelpers

	describe 'GET #show' do
		it "shows a store page" do
			@store_name = "My new store"
			@store_addressline1 = "7110 Rock Valley Court"
			@store_city = "San Diego"
			@store_ca = "CA"
			@store_zip = "92122"
			@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
			@store.save	
			
			user = 'ddadmin'
    		pw = 'idontreallysmoke'
    		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

			get :show, id: @store.id

			expect(response).to render_template :show
		end
	end

	describe 'update_promo' do
		it "update a store's promo requires login" do
			@store_name = "My new store"
			@store_addressline1 = "7110 Rock Valley Court"
			@store_city = "San Diego"
			@store_ca = "CA"
			@store_zip = "92122"
			@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
			@store.save	
			
			user = 'ddadmin'
    		pw = 'idontreallysmoke'
    		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

			#user = create(:admin)

			#sign_in user

    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}

    		expect(response).to redirect_to new_user_session_url
    		expect(@store.promo).to be_nil 
		end

		it "update a store's promo requires store manager role or admin, renders error when user not admin and store unclaimed" do
			@store_name = "My new store"
			@store_addressline1 = "7110 Rock Valley Court"
			@store_city = "San Diego"
			@store_ca = "CA"
			@store_zip = "92122"
			@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
			@store.save	
			
			user = 'ddadmin'
    		pw = 'idontreallysmoke'
    		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

    		user = create(:user)		  				

			# login			
			sign_in user

    		put :update_promo, id: @store.id, store: {promo: 'first store promo'}

    		
    		expect(response).to render_template :error_authorization
    		expect(@store.promo).to be_nil 
    		
		end

		it "update a store's promo works if admin user is logged in and plan_id is 2 or greater" do
			@store_name = "My new store"
			@store_addressline1 = "7110 Rock Valley Court"
			@store_city = "San Diego"
			@store_ca = "CA"
			@store_zip = "92122"
			@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
			@store.plan_id = 3
			@store.save	
			
			user = 'ddadmin'
    		pw = 'idontreallysmoke'
    		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
			
			user = create(:admin)
			
			# login			
			sign_in user
			
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}

    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(@new_promo)

		end

		it "update a store's promo redirects to subscription page if admin user is logged in but plan_id is 1 " do
			@store_name = "My new store"
			@store_addressline1 = "7110 Rock Valley Court"
			@store_city = "San Diego"
			@store_ca = "CA"
			@store_zip = "92122"
			@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
			@store.plan_id = 1
			@store.save	
			
			user = 'ddadmin'
    		pw = 'idontreallysmoke'
    		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

			user = create(:admin)

			# login			
			sign_in user
			@new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: @new_promo}

    		expect(response).to redirect_to subscription_plans_store_url
		end

	end

end
