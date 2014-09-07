class StoresController < ApplicationController

	before_filter :load_store

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
		@urlservice = Simpleweed::Url::Urlservice.new
		@subscription_service = Simpleweed::Subscription::Subscriptionservice.new
		#is the store open?
		
		@is_open = @tds.isStoreOpen(@currenttime, @store)

		@store_items = @store.store_items.order('name ASC')
		@grouped_store_items = @store_items.group_by &:maincategory
		@store_reviews = @store.store_reviews.sort_by {|review| review.sum_votes}.reverse

		if params[:modal]
			render "peak", :layout => false
		end
		
	end

	def edit_photo
		@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/stores/#{@store.id}/avatar/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
		@role_service = Simpleweed::Security::Roleservice.new
		render layout: false
	end

	def update_photo		
	    if @store.update(params[:store].permit(:avatar_url))
			redirect_to store_path(@store)
		else
			# error notice?
			redirect_to store_path(@store)
		end

	end

	#dvu: dead code?  Think we've killed the store browser view...
	def store_preview		
		@tds = Simpleweed::Timedateutil::Timedateservice.new
		@store_items = @store.store_items.order('name ASC')
		@grouped_store_items = @store_items.group_by &:category

		render :layout => false
	end

	def update	  
	 
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
	  @store.destroy
	 
	  redirect_to stores_path
	end

	def archived_items
		@store_items = @store.store_items.only_deleted
	end

	## 
	## Store Edit Endpoints
	##
	def edit_description
		#authorize! :manage, Store		
		render layout: false		
	end

	def update_description				
	    if @store.update(params[:store].permit(:description))
			@store.create_activity key: 'store.update_description'
			redirect_to store_path(@store)
		else
			redirect_to edit_description_store_path(@store)
		end	
	end

	def edit_firsttimepatientdeals		
		render layout: false		
	end

	def update_firsttimepatientdeals		
	    if @store.update(params[:store].permit(:firsttimepatientdeals))
			@store.create_activity key: 'store.update_ftp'
			redirect_to store_path(@store)

			# send email notifications to store followers			
			following_users = @store.followers(User)			
			following_users.each do |user|
				UserMailer.delay.store_has_updated_ftp(user, @store)
			end	

		else
			redirect_to edit_firsttimepatientdeals_store_path(@store)
		end
	end

	def edit_dailyspecials		
		render layout: false		
	end

	def update_dailyspecials		
	    if @store.update(params[:store].permit(:dailyspecialsmonday, :dailyspecialstuesday,
			:dailyspecialswednesday, :dailyspecialsthursday, :dailyspecialsfriday, :dailyspecialssaturday, :dailyspecialssunday))
			
	    	@store.create_activity key: 'store.update_dailyspecials'

			# send email notifications to store followers
			following_users = @store.followers(User)
			following_users.each do |user|
				UserMailer.delay.store_has_updated_dailyspecials(user, @store)
			end	

			redirect_to store_path(@store)
		else
			redirect_to edit_dailyspecials_store_path(@store)
		end
	end

	def edit_contact		
		render layout: false		
	end

	def update_contact		
	    if @store.update(params[:store].permit(:addressline1, :addressline2, :city, :state, :zip, :phonenumber, :email, :website,
	    	:facebook, :twitter, :instagram ))
	    	@store.create_activity key: 'store.update_contact'
			redirect_to store_path(@store)
		else
			redirect_to edit_contact_store_path(@store)
		end
	end

	def edit_features		
		render layout: false		
	end

	def update_features		
	    if @store.update(params[:store].permit(:acceptscreditcards, :atmaccess, :automaticdispensingmachines, :deliveryservice, :handicapaccess,
			:loungearea, :petfriendly, :securityguard, :labtested, :eighteenplus, :twentyoneplus, :hasphotos, :onsitetesting ))
			redirect_to store_path(@store)
		else
			redirect_to edit_features_store_path(@store)
		end
	end

	def edit_announcement		
		render layout: false		
	end

	def update_announcement		
	    if @store.update(params[:store].permit(:announcement))
			@store.create_activity key: 'store.update_announcement'
			redirect_to store_path(@store)			
		else
			redirect_to edit_announcement_store_path(@store)
		end
	end

	def edit_promo		
		render layout: false		
	end

	def update_promo		
	    if @store.update(params[:store].permit(:promo))
			@store.create_activity key: 'store.update_promo'
			redirect_to store_path(@store)			
		else
			redirect_to edit_promo_store_path(@store)
		end
	end

	def edit_deliveryarea		
		render layout: false		
	end

	def update_deliveryarea		
	    if @store.update(params[:store].permit(:deliveryarea))
			redirect_to store_path(@store)
		else
			redirect_to edit_deliveryarea_store_path(@store)
		end
	end

	def edit_hours		
		render layout: false		
	end

	def update_hours		
	    
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
	    	@store.create_activity key: 'store.update_hours'
			redirect_to store_path(@store)
		else
			redirect_to edit_hours_store_path(@store)
		end
	end

	def show_claim
		authenticate_user!("You must sign in as the user who's email appears on that store's page inorder to claim this store")		
	end

	def update_claim
		authenticate_user!("You must sign in as the user who's email appears on that store's page inorder to claim this store")		
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
			redirect_to store_path(@store, :show_edit_popover => 'true')  # dvu: why do we show the popover if they failed to claim?
		end	
	end

	def follow		
		
		if current_user.follow!(@store)
			@store.create_activity key: 'store.followed', owner: current_user

			# notify store owner of the new follower			
			UserMailer.delay.user_following_store(@store, current_user)
		end

		respond_to do |format|
			return format.js {}
		end
	end

	def unfollow		

		current_user.unfollow!(@store)

		respond_to do |format|
			return format.js {}
		end

	end

	def subscription_plans
		# user must be logged in
		# user must be the store owner/manager of this store
		@role_service = Simpleweed::Security::Roleservice.new
		if @role_service.canManageStore(current_user, @store)
			return
		else 
			redirect_to unauthorized_subscription_plans_store_path(@store)
		end
	end

	def unauthorized_subscription_plans

	end

	def subscribe_store
		@stripe_token = params[:stripeToken]
		@plan_id = params[:plan_id]
		@cust_email = params[:stripeEmail]

		if !@store.stripe_customer_id.blank?
			customer = Stripe::Customer.retrieve(@store.stripe_customer_id)
		end

		# create a new customer
		if customer.blank?
			# Create a Customer
			customer = Stripe::Customer.create(
			  :card => @stripe_token,
			  :plan => @plan_id,
			  :email => @cust_email
			)

			@store.stripe_customer_id = customer.id
			@store.plan_id = @plan_id
			@store.save

			flash[:notice] = "thank you for subscribing"
			redirect_to store_path(@store)

		else
			#...else update their plan
			customer.plan = @plan_id
			customer.save
			@store.plan_id = @plan_id
			@store.save

			flash[:notice] = "thank you for subscribing"
			redirect_to store_path(@store)
		end
	end

	def change_credit_card

	end

	def update_credit_card
		
		
		if !@store.stripe_customer_id.blank?
			customer = Stripe::Customer.retrieve(@store.stripe_customer_id)
		end

		token = Stripe::Token.create(
		  card: {
		    number: params[:number],
		    exp_month: params[:date][:month],
		    exp_year: params[:date][:year],
		    cvc: params[:cvc]
		  }
		)

		card = customer.cards.create(card: token.id)
		card.save
		customer.default_card = card.id
		customer.save

		flash[:notice] = 'Saved. Your card information has been updated.'
		redirect_to subscription_plans_store_path		

		rescue Stripe::InvalidRequestError => e
			flash[:warning] = 'Stripe reported an error while updating your card. Please try again.'
			redirect_to change_credit_card_store_path(@store)
		rescue Stripe::CardError => e
			flash[:warning] = e.message
			redirect_to change_credit_card_store_path(@store)
		
	end

	private
    def load_store      
      id = params[:id]      
      if !id.nil?
      	@store = Store.find(params[:id])
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
