require 'spec_helper'

describe FeedPostsController do
	include Devise::TestHelpers

	before(:each) do
		user = 'ddadmin'
		pw = 'idontreallysmoke'
		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)    	
  	end

  	before(:each) do
  		@feed = create(:feed)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  									
  	end

  	before(:each) do
  		@post = create(:feed_post, :user => @user, :feed => @feed)
  	end

  	describe 'new' do
  		it 'requires login' do
  			get :new, feed_id: @feed.id			
			expect(response).to redirect_to new_user_session_url
  		end
  	end

  	describe 'create' do
  		it 'requires login' do
  			post :create, feed_id: @feed.id, feed_post: attributes_for(:feed_post)			
			expect(response).to redirect_to new_user_session_url
  		end
  	end

  	describe 'destroy' do
  		it 'requires login' do
  			delete :destroy, feed_id: @feed.id, id: @post.id
			expect(response).to redirect_to new_user_session_url
  		end
  		it 'fails for a normal user' do
  			sign_in @user
  			delete :destroy, feed_id: @feed.id, id: @post.id
			expect(response).to render_template :error_authorization
  		end
  		it 'works as admin' do
			sign_in @admin									
			expect{ delete :destroy, feed_id: @feed.id, id: @post.id }.to change(FeedPost, :count).by(-1)
		end
  	end #destroy

  	describe 'flag' do
		it 'requires login' do
  			post :flag, feed_id: @feed.id, id: @post.id
			expect(response).to redirect_to new_user_session_url
  		end
  	end

end
