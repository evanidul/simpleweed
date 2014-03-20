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



private
    def load_store
      @store = Store.find(params[:store_id])
    end

private 
	def store_item_params
		params.require(:store_item).permit(:name, :store_id)		
	end		

end
