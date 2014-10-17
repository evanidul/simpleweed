require 'spec_helper'

describe ProfileController do
	include Devise::TestHelpers

	
  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)
  		@other_user = create(:user)		  									
  	end  	

  	describe 'feed' do
  		it 'requires login' do
  			get :feed, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'other users cant see your feed' do
  			sign_in @other_user
  			get :feed, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  		it 'admins cant see your feed' do
  			sign_in @admin
  			get :feed, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  	end

  	describe 'activity' do
  		it 'requires login' do
  			get :activity, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'other users can see your feed so they can follow you' do
  			sign_in @other_user
  			get :activity, id: @user.id
  			expect(response).to render_template :activity
  		end  	
  		it 'admins can see your feed' do
  			sign_in @admin
  			get :activity, id: @user.id
  			expect(response).to render_template :activity
  		end  	
  	end

  	describe 'myreviews' do
  		it 'requires login' do
  			get :myreviews, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'other users cant see your feed' do
  			sign_in @other_user
  			get :myreviews, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  		it 'admins cant see your feed' do
  			sign_in @admin
  			get :myreviews, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  	end

  	describe 'follow' do
  		it 'requires login' do
  			post :follow, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	  		
  	end

  	describe 'unfollow' do
  		it 'requires login' do
  			post :unfollow, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	  		
  	end  	

  	describe 'following' do
  		it 'requires login' do
  			get :following, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'other users cant see your feed' do
  			sign_in @other_user
  			get :following, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  		it 'admins cant see your feed' do
  			sign_in @admin
  			get :following, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  	end

  	# edit_photo allows users to edit photos, but also allows other users to view the photo 
  	describe 'edit_photo' do
  		it 'does not requires login' do
  			get :edit_photo, id: @user.id
  			expect(response).to render_template :edit_photo
  		end  	
  		
  	end

  	describe 'update_photo' do
  		it 'requires login' do
  			get :update_photo, id: @user.id
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'other users cant see your feed' do
  			sign_in @other_user
  			get :update_photo, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  		it 'admins cant see your feed' do
  			sign_in @admin
  			get :update_photo, id: @user.id
  			expect(response).to render_template :error_authorization
  		end  	
  	end

end
