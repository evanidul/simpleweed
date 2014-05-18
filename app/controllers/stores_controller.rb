class StoresController < ApplicationController

	def index
		if params[:search]
      		#@stores = Store.find(:all, :limit => 5).reverse
      		@stores = Store.near(params[:search])
      		# @disableContainerDiv = true;
      		if @stores.size == 0
      			flash[:warning] = "We're sorry!  Your search yielded no results.  Please try again!"
      			redirect_to root_path      			
      		end
    	else
			@stores = Store.all	       
		end
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
		# redirect_to :controller => 'admin/stores', :action => 'index' 			
		redirect_to store_path(@store)
	end

	def show
		@store = Store.find(params[:id])

		if(@store.latitude && @store.longitude)
			@timezone = TZWhere.lookup(@store.latitude, @store.longitude)
		end

		@currenttime = Time.now.in_time_zone(@timezone)
		@secondsSinceMidnight = @currenttime.seconds_since_midnight()

		#0 is Sunday
		@dayint = @currenttime.to_date.wday  
		@day = Date::DAYNAMES[@dayint]

		@tds = Simpleweed::Timedateutil::Timedateservice.new

		@role_service = Simpleweed::Security::Roleservice.new
		#is the store open?
		@is_open = @tds.isStoreOpen(@currenttime, @store)

		@store_items = @store.store_items.order('name ASC')
		@grouped_store_items = @store_items.group_by &:category
		@store_reviews = @store.store_reviews

		if params[:modal]
			render "peak", :layout => false
		end
		
	end

	def store_preview
		@store = Store.find(params[:id])
		@tds = Simpleweed::Timedateutil::Timedateservice.new
		@store_items = @store.store_items.order('name ASC')
		@grouped_store_items = @store_items.group_by &:category

		render :layout => false
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

	## 
	## Store Edit Endpoints
	##
	def edit_description
		#authorize! :manage, Store
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_description
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:description))
			redirect_to store_path(@store)
		else
			redirect_to edit_description_store_path(@store)
		end
	end

	def edit_firsttimepatientdeals
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_firsttimepatientdeals
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:firsttimepatientdeals))
			redirect_to store_path(@store)
		else
			redirect_to edit_firsttimepatientdeals_store_path(@store)
		end
	end

	def edit_dailyspecials
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_dailyspecials
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:dailyspecialsmonday, :dailyspecialstuesday,
			:dailyspecialswednesday, :dailyspecialsthursday, :dailyspecialsfriday, :dailyspecialssaturday, :dailyspecialssunday))
			redirect_to store_path(@store)
		else
			redirect_to edit_dailyspecials_store_path(@store)
		end
	end

	def edit_contact
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_contact
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:addressline1, :addressline2, :city, :state, :zip, :phonenumber, :email, :website,
	    	:facebook, :twitter, :instagram ))
			redirect_to store_path(@store)
		else
			redirect_to edit_contact_store_path(@store)
		end
	end

	def edit_features
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_features
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:acceptscreditcards, :atmaccess, :automaticdispensingmachines, :deliveryservice, :handicapaccess,
			:loungearea, :petfriendly, :securityguard, :labtested, :eighteenplus, :twentyoneplus, :hasphotos, :onsitetesting ))
			redirect_to store_path(@store)
		else
			redirect_to edit_features_store_path(@store)
		end
	end

	def edit_announcement
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_announcement
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:announcement))
			redirect_to store_path(@store)
		else
			redirect_to edit_announcement_store_path(@store)
		end
	end

	def edit_deliveryarea
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_deliveryarea
		@store = Store.find(params[:id])
	    if @store.update(params[:store].permit(:deliveryarea))
			redirect_to store_path(@store)
		else
			redirect_to edit_deliveryarea_store_path(@store)
		end
	end

	def edit_hours
		@store = Store.find(params[:id])
		render layout: false		
	end

	def update_hours
		@store = Store.find(params[:id])
	    
	    first = @store.update(params[:date].permit(:storehourssundayopenhour, :storehourssundayopenminute, :storehourssundayclosehour, :storehourssundaycloseminute,
			:storehoursmondayopenhour, :storehoursmondayopenminute, :storehoursmondayclosehour, :storehoursmondaycloseminute,
			:storehourstuesdayopenhour, :storehourstuesdayopenminute, :storehourstuesdayclosehour, :storehourstuesdaycloseminute,
			:storehourswednesdayopenhour, :storehourswednesdayopenminute, :storehourswednesdayclosehour, :storehourswednesdaycloseminute,
			:storehoursthursdayopenhour, :storehoursthursdayopenminute, :storehoursthursdayclosehour, :storehoursthursdaycloseminute,
			:storehoursfridayopenhour, :storehoursfridayopenminute, :storehoursfridayclosehour, :storehoursfridaycloseminute,
			:storehourssaturdayopenhour, :storehourssaturdayopenminute, :storehourssaturdayclosehour, :storehourssaturdaycloseminute
	    ))
	    
	    second = @store.update(params[:store].permit(:sundayclosed, :mondayclosed, :tuesdayclosed, :wednesdayclosed, :thursdayclosed, :fridayclosed, :saturdayclosed))  
		    
	    if(first && second) 
			redirect_to store_path(@store)
		else
			redirect_to edit_hours_store_path(@store)
		end
	end

	def show_claim
		authenticate_user!("You must sign in as the user who's email appears on that store's page inorder to claim this store")
		@store = Store.find(params[:id])
	end

	def update_claim
		authenticate_user!("You must sign in as the user who's email appears on that store's page inorder to claim this store")
		@store = Store.find(params[:id])
		role_service = Simpleweed::Security::Roleservice.new

		# add store - owner role to logged in user
		# redir to store page with edit tags rendered and tool tips showing them.
		if role_service.findStoreOwnerForStore(@store).size >= 1
			flash[:notice] = "This store has already been claimed.  Please contact support if you feel like this is in error."
			redirect_to store_path(@store, :show_edit_popover => 'true')
		end

		if current_user.email == @store.email
								
			role_service.addStoreOwnerRoleToStore(current_user, @store)
			flash[:notice] = "You have successfully claimed this store.  We've added new edit links below to allow you to manage this store."
			redirect_to store_path(@store, :show_edit_popover => 'true')
		else 			
			flash[:notice] = "Your email must match the email of this store, in order to claim it."
			redirect_to store_path(@store, :show_edit_popover => 'true')
		end	
	end

	# create may only take a name in the future.  Anyway, we may be able to get rid of this block..
	private 
	def store_params
		params.require(:store).permit(:name,:addressline1, :addressline2, :city, :state, :zip, :phonenumber, :dailyspecialsmonday, :dailyspecialstuesday,
			:dailyspecialswednesday, :dailyspecialsthursday, :dailyspecialsfriday, :dailyspecialssaturday, :dailyspecialssunday,
			:acceptscreditcards, :atmaccess, :automaticdispensingmachines, :deliveryservice, :firsttimepatientdeals, :handicapaccess,
			:loungearea, :petfriendly, :securityguard)		
	end		


end
