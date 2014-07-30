class StoreItemsController < ApplicationController

	before_filter :load_store
	
	def index
	  	@store_items = @store.store_items;
	end

	# loaded from modal, so don't use layout
	def new
		# @storeitem = StoreItem.new
		@store_item = @store.store_items.build		
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
		
		@store_item.create_activity key: 'store_item.update_prices'

		if @store_item.save
			redirect_to :action => 'index'
		else
			render 'edit'
		end
	end

	def follow
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
		@store_item = StoreItem.find(params[:id])

		current_user.unfollow!(@store_item)

		respond_to do |format|
			return format.js {}
		end
	end

private
    def load_store
      @store = Store.find(params[:store_id])
    end

private 
	def store_item_params
		params.require(:store_item).permit(:name, :store_id, :description, :thc, :cbd, :cbn, :costhalfgram, :costonegram, :costeighthoz, :costquarteroz,
			:costhalfoz, :costoneoz, :costperunit, :dogo, :strain, :maincategory, :subcategory, :cultivation,
			:privatereserve, :topshelf, :supersize, :glutenfree, :sugarfree, :organic, :dose, :og, :kush, :haze, :storetab, :promo, :image_url)		
	end		

end
