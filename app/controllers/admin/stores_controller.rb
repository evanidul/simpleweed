class Admin::StoresController < ApplicationController

	def index
	  @stores = Store.all	 
	end

	# loaded from modal, so don't use layout
	def new
		render layout: false
	end

	def create
		@store = Store.new(store_params)
		@store.save
		redirect_to :action => 'index'  			
	end

	def show
		@store = Store.find(params[:id])
		render layout: false
	end

	def destroy
	  @store = Store.find(params[:id])
	  @store.destroy
	 
	  redirect_to admin_stores_path
	end


	private 
	def store_params
		params.require(:store).permit(:name,:addressline1,:city, :state, :zip, :phonenumber)		
	end		

end
