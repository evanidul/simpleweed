class StoreItemsController < ApplicationController

	before_filter :load_store
	before_filter :must_be_logged_on_as_store_manager, :except => [:show, :follow, :unfollow]

	# store menu item management page
	def index		
	  	@store_items = @store.store_items
	  	@urlservice = Simpleweed::Url::Urlservice.new
	end

	# loaded from modal, so don't use layout
	def new
		# @storeitem = StoreItem.new
		@store_item = @store.store_items.build		
		@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/stores/#{@store.id}/items/#{@store_item.id}/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
		render layout: false		
	end

	def create		
		@store_item =  @store.store_items.create(store_item_params)		
		if @store_item.save
			@store.activity_params = {:store_item_id => @store_item.id}			
			@store.create_activity key: 'store.add_item'
		end
		redirect_to :action => 'index'  			
	end

	def show
		@store_item = StoreItem.find(params[:id])
		@currenttime = Time.now.in_time_zone(@timezone)
		@secondsSinceMidnight = @currenttime.seconds_since_midnight()

		#0 is Sunday
		@dayint = @currenttime.to_date.wday  
		@day = Date::DAYNAMES[@dayint]
		@tds = Simpleweed::Timedateutil::Timedateservice.new	
		@urlservice = Simpleweed::Url::Urlservice.new	
		#is the store open?		
		@is_open = @tds.isStoreOpen(@currenttime, @store)
		@role_service = Simpleweed::Security::Roleservice.new

		@item_reviews = @store_item.store_item_reviews
		
		@storetab = params[:storetab]
		@reviewtab = params[:reviewtab]			
		
		render layout: false
	end

	def edit		
	  	@store_item = StoreItem.find(params[:id])
 		@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/stores/#{@store.id}/items/#{@store_item.id}/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
	  	render layout: false
	end

	def update
		@store_item = StoreItem.find(params[:id])

		@store_item.assign_attributes(store_item_params)
		# detect changes
		changes = @store_item.changes

		# handle price changes		
		
		price_change_keys = ["costhalfgram","costhalfgram","costonegram","costeighthoz","costquarteroz","costhalfoz","costoneoz"]
		price_change_array = changes.keys & price_change_keys
		has_price_change = !price_change_array.empty?
		
		if has_price_change
			@store_item.create_activity key: 'store_item.update_prices'
		end

		if @store_item.save
			redirect_to :action => 'index'
		else
			render 'edit'
		end
	end

	def follow
		if(!authenticate_user!("You must be logged in to follow an item"))
			return
		end
		@store_item = StoreItem.find(params[:id])
		
		if current_user.follow!(@store_item)

			@store_item.create_activity key: 'store_item.followed', owner: current_user

			# notify store owner of the new follower			
			UserMailer.delay.user_following_item(@store_item, current_user)

		end

		respond_to do |format|
			return format.js {}
		end
	end

	def unfollow
		if(!authenticate_user!("You must be logged in to unfollow an item"))
			return
		end
		@store_item = StoreItem.find(params[:id])

		current_user.unfollow!(@store_item)

		respond_to do |format|
			return format.js {}
		end
	end

	def delete_prompt
		@store_item = StoreItem.find(params[:id])
	end

	def destroy
		# TODO: add authorization
		# roleservice = Simpleweed::Security::Roleservice.new
		# assert_equal(true, roleservice.canManagePost(user) , 'admins should be able to manage posts')
		@store_item = StoreItem.find(params[:id])
		if @store_item			
			@store_item.destroy
	    	flash[:notice] = @store_item.name + " has been archived"
	    end
		redirect_to store_store_items_path(@store)
	end

	def undestroy
		@store_item = StoreItem.only_deleted.find(params[:id])
		if @store_item
			StoreItem.restore(@store_item.id, :recursive => true)
			flash[:notice] = @store_item.name + " has been unarchived"
		end
		redirect_to store_store_items_path(@store)		
	end

	def restore_modal
		@store_item = StoreItem.only_deleted.find(params[:id])				
		@role_service = Simpleweed::Security::Roleservice.new		
		render layout: false
	end

private
    def load_store    	
      @store = Store.find(params[:store_id])
    end

private 
	def store_item_params
		params.require(:store_item).permit(:name, :store_id, :description, :thc, :cbd, :cbn, :costhalfgram, :costonegram, :costeighthoz, :costquarteroz,
			:costhalfoz, :costoneoz, :costperunit, :dogo, :strain, :maincategory, :subcategory, :cultivation, :usetype,
			:privatereserve, :topshelf, :supersize, :glutenfree, :sugarfree, :organic, :dose, :og, :kush, :haze, :storetab, :promo, :image_url)		
	end		

end
