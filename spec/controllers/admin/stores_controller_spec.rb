require 'spec_helper'

describe Admin::StoresController do
	include Devise::TestHelpers

	

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

	describe 'new' do
  		it 'requires login' do
			get :new
			expect(response).to redirect_to new_user_session_url
		end
		it 'fails as a normal user' do
			sign_in @user
			get :new
			expect(response).to render_template :error_authorization
		end
		it 'works as admin' do
			sign_in @admin
			get :new
			expect(response).to render_template :new
		end
	end #new

	
end
