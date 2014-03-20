class StoreitemsController < ApplicationController

	before_filter :load_store
	
	def index
	  	
	end




private
    def load_store
      @store = Store.find(params[:store_id])
    end
end
