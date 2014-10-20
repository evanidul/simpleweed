require 'spec_helper'

describe FeedPostsController do
	include Devise::TestHelpers

	
  	before(:each) do
  		@feed = create(:feed)
  	end

  	before(:each) do
  		@admin = create(:admin)
  		@user = create(:user)		  			
      @user2 = create(:user)						
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

    describe 'edit' do
      it 'requires login' do
        get :edit, feed_id: @feed.id, id: @post.id
        expect(response).to redirect_to new_user_session_url
      end
      it 'requires you to be the post owner' do
        sign_in @user2
        get :edit, feed_id: @feed.id, id: @post.id
        expect(response).to render_template :error_authorization
      end
      it 'works if you logged in as the post owner' do
        sign_in @user
        get :edit, feed_id: @feed.id, id: @post.id
        expect(response).to render_template :edit
      end
    end

    describe 'update' do
      it 'requires login' do
        new_post_text = "this is awesome" 
        patch :update, feed_id: @feed.id, id: @post.id, feed_post: {post: new_post_text}
        expect(response).to redirect_to new_user_session_url      
      end
      it 'requires you to be the post owner' do
        sign_in @user2
        new_post_text = "this is awesome" 
        patch :update, feed_id: @feed.id, id: @post.id, feed_post: {post: new_post_text}
        expect(response).to render_template :error_authorization
      end
      it 'works if you logged in as the post owner' do
        sign_in @user
        new_post_text = "this is awesome" 
        patch :update, feed_id: @feed.id, id: @post.id, feed_post: {post: new_post_text}
        expect(response).to redirect_to :feed_feed_post
        @post.reload
        expect(@post.post).to eq(new_post_text)      

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
