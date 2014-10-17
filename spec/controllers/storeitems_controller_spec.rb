require 'spec_helper'

describe StoreItemsController do
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

  	describe 'index' do
  		it 'requires login' do
			get :index, store_id: @store.id
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :index, store_id: @store.id
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :index, store_id: @store.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			get :index, store_id: @store.id
			expect(response).to render_template :index			
		end
  	end #index

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
			post :create, store_id: @store.id, store_item: attributes_for(:store_item)			
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			post :create, store_id: @store.id, store_item: attributes_for(:store_item)			
			expect(response).to render_template :error_authorization
		end
		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			post :create, store_id: @store.id, store_item: attributes_for(:store_item)			
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
						
			expect{post :create, store_id: @store.id, store_item: attributes_for(:store_item)}.to change(StoreItem, :count).by(1)			
			expect(response).to redirect_to :store_store_items
		end
  	end #create

  	describe 'show' do
  		it 'does not require login' do
  			get :show, store_id: @store.id, id: @item.id
  			expect(response).to render_template :show
  		end

  	end #show

  	describe 'edit' do
  		it 'requires login' do
  			get :edit, store_id: @store.id, id: @item.id
  			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails as a normal user' do
  			sign_in @user
  			get :edit, store_id: @store.id, id: @item.id
  			expect(response).to render_template :error_authorization
  		end
  		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :edit, store_id: @store.id, id: @item.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
						
			get :edit, store_id: @store.id, id: @item.id
			expect(response).to render_template :edit
		end
  	end #edit

  	describe 'update' do
  		it 'requires login' do
  			new_description = "this is awesome"
  			patch :update, store_id: @store.id, id: @item.id, store_item: {description: new_description}
  			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails as a normal user' do
  			sign_in @user
  			new_description = "this is awesome"	
  			patch :update, store_id: @store.id, id: @item.id, store_item: {description: new_description}
  			expect(response).to render_template :error_authorization
  		end
  		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			new_description = "this is awesome"	
			patch :update, store_id: @store.id, id: @item.id, store_item: {description: new_description}
			expect(response).to render_template :error_authorization			
		end
  		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
						
			new_description = "this is awesome"			
			patch :update, store_id: @store.id, id: @item.id, store_item: {description: new_description}
			expect(response).to redirect_to :store_store_items
			@item.reload
			expect(@item.description).to eq(new_description)			
		end
  	end #update

  	describe 'follow' do
  		it 'requires login' do
  			post :follow, store_id: @store.id, id: @item.id
			expect(response).to redirect_to new_user_session_url
  		end
  	end # follow

  	describe 'unfollow' do
		it 'requires login' do
  			post :unfollow, store_id: @store.id, id: @item.id
			expect(response).to redirect_to new_user_session_url
  		end
  	end #unfollow

  	describe 'destroy' do
  		it 'requires login' do
  			delete :destroy, store_id: @store.id, id: @item.id
  			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails as a normal user' do
  			sign_in @user
  			delete :destroy, store_id: @store.id, id: @item.id
  			expect(response).to render_template :error_authorization
  		end
  		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			delete :destroy, store_id: @store.id, id: @item.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user
									
			expect{ delete :destroy, store_id: @store.id, id: @item.id }.to change(StoreItem, :count).by(-1)
			expect(response).to redirect_to :store_store_items
			expect(request.flash[:notice]).to eq(@item.name + " has been archived")
		end
  	end #destroy

  	describe 'undestroy' do
  		it 'requires login' do
  			post :undestroy, store_id: @store.id, id: @item.id
  			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails as a normal user' do
  			sign_in @user
  			post :undestroy, store_id: @store.id, id: @item.id
  			expect(response).to render_template :error_authorization
  		end
  		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			post :undestroy, store_id: @store.id, id: @item.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			# have to destroy an item first...
			expect{ delete :destroy, store_id: @store.id, id: @item.id }.to change(StoreItem, :count).by(-1)

			expect{ post :undestroy, store_id: @store.id, id: @item.id}.to change(StoreItem, :count).by(1)
			expect(response).to redirect_to :store_store_items
			expect(request.flash[:notice]).to eq(@item.name + " has been unarchived")
		end
  	end #undestroy

  	describe 'restore_modal' do
  		it 'requires login'  do
  			get :restore_modal, store_id: @store.id, id: @item.id
  			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails as a normal user' do
  			sign_in @user
  			get :restore_modal, store_id: @store.id, id: @item.id
  			expect(response).to render_template :error_authorization
  		end
  		it 'fails as another store owner' do
			@store_other = create(:store)
			@store_owner_other = create(:user)
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@store_owner_other, @store_other)
			sign_in @store_owner_other

			get :restore_modal, store_id: @store.id, id: @item.id
			expect(response).to render_template :error_authorization			
		end
		it 'works as store owner' do
			role_service = Simpleweed::Security::Roleservice.new							
			role_service.addStoreOwnerRoleToStore(@user, @store)
			sign_in @user

			# have to destroy an item first...
			expect{ delete :destroy, store_id: @store.id, id: @item.id }.to change(StoreItem, :count).by(-1)
									
			get :restore_modal, store_id: @store.id, id: @item.id
			expect(response).to render_template :restore_modal			
		end
  	end #restore_modal

end
