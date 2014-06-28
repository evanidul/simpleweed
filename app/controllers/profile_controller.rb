class ProfileController < ApplicationController

	def feed				
		@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)

		following_user_ids = @profile_user.followees(User).collect(&:id)  
		following_store_ids = @profile_user.followees(Store).collect(&:id)  
		following_store_item_ids = @profile_user.followees(StoreItem).collect(&:id)  

		@user_is_viewing_own_profile = false;
		if current_user.id == @profile_owner_id
			@user_is_viewing_own_profile = true;
		end		
		@active_tab = "feed-link-li"
		#@activities = PublicActivity::Activity.order("created_at desc")
		@useractivities = PublicActivity::Activity.order("created_at desc").where(owner_id: following_user_ids, owner_type: "User")

		@storeactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_ids, trackable_type: "Store")

		@storeitemactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_item_ids, trackable_type: "StoreItem")

		# only works well when arrays are equal sizes
		#@activities = @useractivities.zip(@storeactivities).flatten.compact

		@unsortedactivities = @useractivities + @storeactivities +@storeitemactivities

		#	@activities.sort_by(&:created_at)
		@activities = @unsortedactivities.sort_by { |obj| obj.created_at }.reverse

	end	

	def activity		
		#current_user = the guy who is viewing the page
		# params[:id] = the owner of the profile
		@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:id], owner_type: "User")		
		@user_is_viewing_own_profile = false;
		if current_user.id == @profile_owner_id
			@user_is_viewing_own_profile = true;
		end
		@active_tab = "my-activity-li"
		
	end

	def follow

		@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)
		# can't follow yourself
		if current_user.id == @profile_owner_id
			return false
		end

		current_user.follow!(@profile_user)


	end

end
