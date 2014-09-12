require 'spec_helper'

describe FeedPostCommentsController do
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


  	describe 'create' do
  		it 'requires login' do
  			post :create, feed_id: @feed.id, feed_post_id: @post.id, feed_post_comment: attributes_for(:feed_post_comment)						
			expect(response).to redirect_to new_user_session_url
  		end
  	end


end
