class StoresController < ApplicationController

	def index
	  @stores = Store.all	 
	end

	# loaded from modal, so don't use layout
	def new
		render layout: false		
	end

	# called from /admin/stores, so send it back to that controller
	def create
		@store = Store.new(store_params)
		@store.save
		# redirect_to :action => 'index' 
		redirect_to :controller => 'admin/stores', :action => 'index' 			
	end


	def show
		@store = Store.find(params[:id])
		@store_items = @store.store_items.order('name ASC')
		@grouped_store_items = @store_items.group_by &:category
		# render layout: false, 'peak'
		if params[:modal]
			render "peak", :layout => false
		end
		
	end

	def update
	  @store = Store.find(params[:id])
	 
	  if @store.update(params[:store].permit(:name,:addressline1, :addressline2, :city, :state, :zip, :phonenumber, :dailyspecialsmonday, :dailyspecialstuesday,
			:dailyspecialswednesday, :dailyspecialsthursday, :dailyspecialsfriday, :dailyspecialssaturday, :dailyspecialssunday,
			:acceptscreditcards, :atmaccess, :automaticdispensingmachines, :deliveryservice, :firsttimepatientdeals, :handicapaccess,
			:loungearea, :petfriendly, :securityguard))
	    # redirect_to :action => 'index'
	    redirect_to :controller => 'admin/stores', :action => 'index'
	  else
	    render 'edit'
	  end
	end

	def destroy
	  @store = Store.find(params[:id])
	  @store.destroy
	 
	  redirect_to stores_path
	end


	private 
	def store_params
		params.require(:store).permit(:name,:addressline1, :addressline2, :city, :state, :zip, :phonenumber, :dailyspecialsmonday, :dailyspecialstuesday,
			:dailyspecialswednesday, :dailyspecialsthursday, :dailyspecialsfriday, :dailyspecialssaturday, :dailyspecialssunday,
			:acceptscreditcards, :atmaccess, :automaticdispensingmachines, :deliveryservice, :firsttimepatientdeals, :handicapaccess,
			:loungearea, :petfriendly, :securityguard)		
	end		


end
