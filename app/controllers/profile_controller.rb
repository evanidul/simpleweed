class ProfileController < ApplicationController

	def feed				
		@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)

		following_ids_of_user_profile = @profile_user.followees(User).collect(&:id)  
		@user_is_viewing_own_profile = false;
		if current_user.id == @profile_owner_id
			@user_is_viewing_own_profile = true;
		end		
		@active_tab = "feed-link-li"
		#@activities = PublicActivity::Activity.order("created_at desc")
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: following_ids_of_user_profile, owner_type: "User")
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
