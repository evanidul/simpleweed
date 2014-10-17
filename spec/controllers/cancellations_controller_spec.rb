require 'spec_helper'

describe CancellationsController do
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
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :new, store_id: @store.id
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :new, store_id: @store.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			get :new, store_id: @store.id
			expect(response).to render_template :new			
		end
	end #new

	describe 'create' do
		it 'requires login' do
			post :create, store_id: @store.id, cancellation: attributes_for(:cancellation)			
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			post :create, store_id: @store.id, cancellation: attributes_for(:cancellation)			
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			post :create, store_id: @store.id, cancellation: attributes_for(:cancellation)			
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			# how to mock STRIPE out?
			# role_service = Simpleweed::Security::Roleservice.new							
			# role_service.addStoreOwnerRoleToStore(@user, @store)
			# sign_in @user
						
			# expect{post :create, store_id: @store.id, cancellation: attributes_for(:cancellation)}.to change(StoreItem, :count).by(1)			
			# expect(response).to redirect_to store_path(@store)
		end
  	end #create
	
end
