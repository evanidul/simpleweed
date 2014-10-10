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

	describe 'update_claim' do
		it 'requires login' do
			put :update_claim, id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
		it 'does not work if someone else has claimed it' do			
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store)

			sign_in @user
			put :update_claim, id: @store.id
			expect(response).to redirect_to store_url			
			expect(request.flash[:notice]).to eq("This store has already been claimed.  Please contact support if you feel like this is in error.")
		end
		it 'doesnt work if your email doesnt match the store email' do
			sign_in @user
			put :update_claim, id: @store.id
			expect(response).to redirect_to store_url			
			expect(request.flash[:notice]).to eq("Your email must match the email of this store, in order to claim it.")
		end
		it 'should work if its unclaimed and your email matches' do
			@store.email = @user.email
			@store.save		

			sign_in @user
			put :update_claim, id: @store.id
			extra_params = "?show_edit_popover=true"
			expect(response).to redirect_to store_url + extra_params			#has extra query param to show popup
			expect(request.flash[:notice]).to eq("You have successfully claimed this store.  We've added new edit links below to allow you to manage this store.")
		end
	end

	describe 'archived_items' do
		it 'requires login' do
			get :archived_items, id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :archived_items, id: @store.id
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :archived_items, id: @store.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			get :archived_items, id: @store.id
			expect(response).to render_template :archived_items			
		end

	end

	describe 'subscription_plans' do
		it 'requires login' do
			get :subscription_plans, id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :subscription_plans, id: @store.id
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :subscription_plans, id: @store.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			get :subscription_plans, id: @store.id
			expect(response).to render_template :subscription_plans			
		end

	end

	describe 'update_deliveryarea' do
		it 'works as admin, plan_id is 1 or greater or plan_id is nil' do
			sign_in @admin

			new_delivery_area = "ohio"
			put :update_deliveryarea, id: @store.id, store: {deliveryarea: new_delivery_area}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.deliveryarea).to eq(new_delivery_area)
		end

		it 'works for store managers' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_delivery_area = "ohio"
			put :update_deliveryarea, id: @store.id, store: {deliveryarea: new_delivery_area}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.deliveryarea).to eq(new_delivery_area)
		end

		it "requires login" do
			new_delivery_area = "ohio"
			put :update_deliveryarea, id: @store.id, store: {deliveryarea: new_delivery_area}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.deliveryarea).to eq('none.')
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		new_delivery_area = "ohio"
			put :update_deliveryarea, id: @store.id, store: {deliveryarea: new_delivery_area}    		
    		expect(response).to render_template :error_authorization
    		expect(@store.deliveryarea).to eq('none.')
		end

	end #update_deliveryarea

	describe 'update_hours' do
		it 'works as admin, plan_id is 1 or greater or plan_id is nil' do
			sign_in @admin

			new_sundayopen = 10
			put :update_hours, id: @store.id, date: {storehourssundayopenhour: new_sundayopen}, store: {}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.storehourssundayopenhour).to eq(new_sundayopen)
		end

		it 'works for store managers' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_sundayopen = 10
			put :update_hours, id: @store.id, date: {storehourssundayopenhour: new_sundayopen}, store: {}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.storehourssundayopenhour).to eq(new_sundayopen)
		end

		it "requires login" do
			new_sundayopen = 10
			put :update_hours, id: @store.id, date: {storehourssundayopenhour: new_sundayopen}, store: {}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.storehourssundayopenhour).to be_nil
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		new_sundayopen = 10
			put :update_hours, id: @store.id, date: {storehourssundayopenhour: new_sundayopen}, store: {}
    		expect(response).to render_template :error_authorization
    		expect(@store.storehourssundayopenhour).to be_nil
		end

	end

	describe 'update_contact' do
		it 'works as admin, plan_id is 1 or greater or plan_id is nil' do
			sign_in @admin

			new_city = 'las vegas'
			put :update_contact, id: @store.id, store: {city: new_city}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.city).to eq(new_city)
    		expect(@store.plan_id).to be_nil
		end

		it 'works for store managers' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_city = 'las vegas'
			put :update_contact, id: @store.id, store: {city: new_city}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.city).to eq(new_city)
    		expect(@store.plan_id).to be_nil
		end

		it "requires login" do
			new_city = 'las vegas'			
    		put :update_contact, id: @store.id, store: {city: new_city}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.city).to eq("San Diego")
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		new_city = 'las vegas'			
    		put :update_contact, id: @store.id, store: {city: new_city}
    		expect(response).to render_template :error_authorization
    		expect(@store.city).to eq("San Diego")
		end
		it 'works for a store with a plan of 2' do
			@store.plan_id = 2
			@store.save										
			sign_in @admin

			new_city = 'las vegas'
			put :update_contact, id: @store.id, store: {city: new_city}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.city).to eq(new_city)
		end

	end

	describe 'create' do
		it "works as an admin" do
			sign_in @admin			
			expect{post :create, store: attributes_for(:store)}.to change(Store, :count).by(1)			
		end

		it "fails as a normal user" do
			sign_in @user
			expect{post :create, store: attributes_for(:store)}.to change(Store, :count).by(0)			
			expect(response).to render_template :error_authorization
		end
	end # create

	describe 'update_announcement' do
		it "works if admin user is logged in and plan_id is 2 or greater" do						
			@store.plan_id = 2		
			@store.save															
			sign_in @admin			
			
			new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.announcement).to eq(new_announcement)
		end

		it "works if the user is a store manager and plan_id is 2 or greater" do
			@store.plan_id = 3			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.announcement).to eq(new_announcement)
		end

		it "requires login" do
			#sign_in user
    		new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.announcement).to eq('none.')
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}
    		expect(response).to render_template :error_authorization
    		expect(@store.announcement).to eq('none.')
		end

		it "redirects to subscription page if plan_id is 1 and logged in as store owner " do						
			@store.plan_id = 1
			@store.save		
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)								
			sign_in @user
			new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}    		
    		expect(response).to redirect_to subscription_plans_store_url
    		expect(@store.announcement).to eq('none.')
		end

		it "if plan_id is 1 but admin user changes announcement, change goes through " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin
			new_announcement = 'new stuff here'
    		put :update_announcement, id: @store.id, store: {announcement: new_announcement}    		
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.announcement).to eq(new_announcement)
		end

	end #update_announcement

	describe 'update_promo' do
		it "works if admin user is logged in and plan_id is 2 or greater" do						
			@store.plan_id = 3			
			@store.save															
			sign_in @admin			
			
			new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: new_promo}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(new_promo)
		end

		it "works if the user is a store manager and plan_id is 2 or greater" do
			@store.plan_id = 3			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: new_promo}
    		expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.promo).to eq(new_promo)
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
			new_promo = 'first store promo'
    		put :update_promo, id: @store.id, store: {promo: new_promo}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_promo

	describe 'update_description' do
		it "works if admin logs in and plan_id is 2 or greater" do
			@store.plan_id = 2
			@store.save
			sign_in @admin
			
			new_description = 'this store is awesome'
			put :update_description, id: @store.id, store: {description: new_description}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.description).to eq(new_description)
		end

		it "works if store owner logs in and plan_id is 2 or greater" do
			@store.plan_id = 2			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			new_description = 'this store is awesome'
			put :update_description, id: @store.id, store: {description: new_description}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.description).to eq(new_description)
		end

		it "requires login" do
			#sign_in user
			new_description = 'this store is awesome'
    		put :update_description, id: @store.id, store: {description: new_description}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.description).to eq("none.")
		end

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
			new_description = 'this store is awesome'
    		put :update_description, id: @store.id, store: {description: new_description}
    		expect(response).to render_template :error_authorization
    		expect(@store.description).to eq("none.")     		
		end

		it "redirects to subscription page if plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin

			new_description = 'this store is awesome'
    		put :update_description, id: @store.id, store: {description: new_description}
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

	describe 'update_photo' do
		it "works if admin logs in and plan_id is 2 or greater" do
			@store.plan_id = 3
			@store.save
			sign_in @admin
			
			avatar_url = "http://something.com/image.jpg"			
			put :update_photo, id: @store.id, store: {avatar_url: avatar_url}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.avatar_url).to eq(avatar_url)    		
		end

		it "works if store owner logs in and plan_id is 2 or greater" do
			@store.plan_id = 2			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			avatar_url = "http://something.com/image.jpg"			
			put :update_photo, id: @store.id, store: {avatar_url: avatar_url}
			expect(response).to redirect_to store_url
    		@store.reload
    		expect(@store.avatar_url).to eq(avatar_url)    		
		end

		it "requires login" do
			#sign_in user
			avatar_url = "http://something.com/image.jpg"			
			put :update_photo, id: @store.id, store: {avatar_url: avatar_url}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.avatar_url).to be_nil     		    		
		end		

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		avatar_url = "http://something.com/image.jpg"			
			put :update_photo, id: @store.id, store: {avatar_url: avatar_url}
    		expect(response).to render_template :error_authorization
    		expect(@store.avatar_url).to be_nil     		    		
		end

		it "redirects to subscription page if plan_id is 1 " do						
			@store.plan_id = 1
			@store.save										
			sign_in @admin

			avatar_url = "http://something.com/image.jpg"			
			put :update_photo, id: @store.id, store: {avatar_url: avatar_url}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end	#update_photo

	describe 'update_dailyspecials' do
		it "works if admin logs in and plan_id is 3 or greater" do
			@store.plan_id = 3
			@store.save
			sign_in @admin
			
			dailyspecialsmonday = "cookies"
			put :update_dailyspecials, id: @store.id, store: {dailyspecialsmonday: dailyspecialsmonday}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.dailyspecialsmonday).to eq(dailyspecialsmonday)    		
		end

		it "works if store owner logs in and plan_id is 3 or greater" do
			@store.plan_id = 3			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			dailyspecialsmonday = "cookies"
			put :update_dailyspecials, id: @store.id, store: {dailyspecialsmonday: dailyspecialsmonday}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.dailyspecialsmonday).to eq(dailyspecialsmonday)    		
		end

		it "requires login" do
			#sign_in user
			dailyspecialsmonday = "cookies"
			put :update_dailyspecials, id: @store.id, store: {dailyspecialsmonday: dailyspecialsmonday}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.dailyspecialsmonday).to eq("none.")    		
		end		

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		dailyspecialsmonday = "cookies"
			put :update_dailyspecials, id: @store.id, store: {dailyspecialsmonday: dailyspecialsmonday}
    		expect(response).to render_template :error_authorization
    		expect(@store.dailyspecialsmonday).to eq("none.")    		
		end

		it "redirects to subscription page if plan_id is 2 " do						
			@store.plan_id = 2
			@store.save										
			sign_in @admin

			dailyspecialsmonday = "cookies"
			put :update_dailyspecials, id: @store.id, store: {dailyspecialsmonday: dailyspecialsmonday}
    		expect(response).to redirect_to subscription_plans_store_url
		end
	end #update_dailyspecials

	describe 'update_firsttimepatientdeals' do
		it "works if admin logs in and plan_id is 3 or greater" do
			@store.plan_id = 3
			@store.save
			sign_in @admin
			
			firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.firsttimepatientdeals).to eq(firsttimepatientdeals)    		
		end

		it "works if store owner logs in and plan_id is 3 or greater" do
			@store.plan_id = 3			
			@store.save								
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
			
			firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
			expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.firsttimepatientdeals).to eq(firsttimepatientdeals)    		
		end

		it "requires login" do
			#sign_in user
			firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
    		expect(response).to redirect_to new_user_session_url
    		expect(@store.firsttimepatientdeals).to be_nil
		end				

		it "renders error when user not admin nor store owner" do			    		
			sign_in @user
    		firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
    		expect(response).to render_template :error_authorization
    		expect(@store.firsttimepatientdeals).to be_nil
		end		

		it "redirects to subscription page if plan_id is 2, user is a store owner " do						
			@store.plan_id = 2
			@store.save	
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)											
			sign_in @user

			firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
    		expect(response).to redirect_to subscription_plans_store_url
		end
		it "works if plan_id is 2, but user is an admin " do						
			@store.plan_id = 2
			@store.save										
			sign_in @admin

			firsttimepatientdeals = "i'll give you free pot"
			put :update_firsttimepatientdeals, id: @store.id, store: {firsttimepatientdeals: firsttimepatientdeals}
    		expect(response).to redirect_to store_url
    		@store.reload    		
    		expect(@store.firsttimepatientdeals).to eq(firsttimepatientdeals)    		
		end
	end #update_firsttimepatientdeals

	describe 'follow' do
		it 'requires login' do
			post :follow, id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
	end #follow

	describe 'unfollow' do
		it 'requires login' do
			post :unfollow, id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
	end #unfollow
end
