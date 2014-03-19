class StoreController < ApplicationController

	def index
	  @stores = Store.all	 
	end

end
