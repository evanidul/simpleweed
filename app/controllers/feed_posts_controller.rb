class FeedPostsController < ApplicationController

	before_filter :load_feed

	def new
		if(!authenticate_user!("You must be logged in to create a post"))
			return
		end			
		render layout: false		
	end

	def create		
		if(!authenticate_user!("You must be logged in to create a post"))
			return
		end			

		@feed_post =  @feed.feed_posts.create(feed_post_params)		
		@feed_post.user = current_user

		# need to verify that it has at least :post or :link set.  maybe check at model layer
		@feed_post.save		
		redirect_to feed_path(@feed.id)
	end

	def show
		@feeds = Feed.all
		@roleservice = Simpleweed::Security::Roleservice.new
	end

	def prompt_delete
		# TODO: add authorization
		# roleservice = Simpleweed::Security::Roleservice.new
		# assert_equal(true, roleservice.canManagePost(user) , 'admins should be able to manage posts')
		render layout: false
	end

	def destroy
		if(!authenticate_user!("You must be logged as admin to delete a feed post"))
			return
		end			

		if !current_user.has_role?(:admin)
			#redirect_to error_authorization_store_path(@store)
			render "stores/error_authorization" and return
		end		

		if @post			
			@post.destroy
	    	flash[:danger] = "post has been deleted"
	    end
		redirect_to feed_path(@feed.id)
	end

	# show modal for adding flag reason
	def add_flag
		render layout: false
	end

	# process the flag add post from add_flag
	def flag	
		if(!authenticate_user!("You must be logged as admin to delete a feed post"))
			return
		end				
		postparams = params[:flag].permit(:reason)
		
		begin
			current_user.flag!(@post, postparams[:reason] )
		rescue MakeFlaggable::Exceptions::AlreadyFlaggedError
			return render 'already_flagged'
		end

		respond_to do |format|			
			return format.js {}
		end
	end

	def already_flagged
		respond_to do |format|			
			return format.js {}
		end
	end

	private 
	def feed_post_params
		params.require(:feed_post).permit(:title, :post, :link)		
	end		

	private
    def load_feed
      @feed = Feed.find(params[:feed_id])
      if params[:id]
      	@post = FeedPost.find(params[:id])
      end
    end

end
