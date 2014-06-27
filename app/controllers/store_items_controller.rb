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
		@store_item.save
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
		render layout: false
	end

	def edit		
	  	@store_item = StoreItem.find(params[:id])
	  	render layout: false
	end

	def update
		@store_item = StoreItem.find(params[:id])

		@store_item.assign_attributes(store_item_params)
		# detect changes
		@store_item.changes
		#@store_item.changes["strain"]

		# store / create activity
		
		#@store.create_activity key: 'store.update_announcement'

		if @store_item.save
			redirect_to :action => 'index'
		else
			render 'edit'
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
			:privatereserve, :topshelf, :supersize, :glutenfree, :sugarfree, :organic, :dose, :og, :kush, :haze, :storetab)		
	end		

end
