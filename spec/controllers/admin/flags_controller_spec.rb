require 'spec_helper'

describe Admin::FlagsController do
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

  	describe 'index' do
  		it 'requires login' do
			get :index
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :index
			expect(response).to render_template :error_authorization
		end
		it 'works as admin' do
			sign_in @admin
			get :index
			expect(response).to render_template :index
		end
	end #index

	describe 'destroy' do
		it 'requires login' do
			delete :destroy
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			delete :destroy
			expect(response).to render_template :error_authorization
		end
		pending 'works as admin'  #covered in selenium		
	end #destroy


end
