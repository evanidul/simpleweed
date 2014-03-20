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
		# @store = Store.find(store_item_params[:store_id])
		@store_item =  @store.store_items.create(store_item_params)
		# @store_item = StoreItem.new(store_item_params)
		@store_item.save
		redirect_to :action => 'index'  			
	end

	def show
		@store_item = StoreItem.find(params[:id])
	end

	def edit		
	  	@store_item = StoreItem.find(params[:id])
	  	render layout: false
	end

	def update
		@store_item = StoreItem.find(params[:id])

		if @store_item.update(store_item_params)
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
		params.require(:store_item).permit(:name, :store_id, :description)		
	end		

end
