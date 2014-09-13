class Admin::StoresController < ApplicationController

	before_filter :must_be_admin

	def index  		
	  	@stores = Store.all	 
	end

	# loaded from modal, so don't use layout
	def new		
		@store = Store.new
		render layout: false
	end

	# DEADCODE?
	# def create
	# 	authorize! :manage, Store
	# 	#@store = Store.new(store_params)
	# 	#@store.save
	# 	# redirect_to :action => 'index'
	# 	# redirect_to store_path(@store)  
	# 	redirect_to :controller => 'stores', :action => 'show'			
	# end

	# dead code?
	# def show		
	# 	@store = Store.find(params[:id])
	# 	render layout: false
	# end

	# def edit		
	#   	@store = Store.find(params[:id])
	# end



	# def destroy		
	#   	@store = Store.find(params[:id])
	#   	@store.destroy
	 
	#   	redirect_to admin_stores_path
	# end


	private 
	def store_params
		params.require(:store).permit(:name,:addressline1,:city, :state, :zip, :phonenumber)		
	end		

end
