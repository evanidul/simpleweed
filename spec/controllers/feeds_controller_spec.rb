require 'spec_helper'

describe FeedsController do
	include Devise::TestHelpers

	before(:each) do
		user = 'ddadmin'
		pw = 'idontreallysmoke'
		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)    	
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

  	describe 'create' do
  		it 'requires login' do
  			get :new
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'fails as normal user' do
  			sign_in @user
  			get :new
  			expect(response).to render_template :error_authorization
  		end  	
  	end

  	describe 'create' do
  		it 'requires login' do
  			post :create, feed: attributes_for(:feed)
  			expect(response).to redirect_to new_user_session_url
  		end  	
  		it 'fails as normal user' do
  			sign_in @user
  			post :create, feed: attributes_for(:feed)
  			expect(response).to render_template :error_authorization
  		end  	
  	end


end
