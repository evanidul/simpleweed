class ProfileController < ApplicationController

	def feed				
		@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)

		following_user_ids = @profile_user.followees(User).collect(&:id)  

		# always follow yourself
		following_user_ids << current_user.id

		following_store_ids = @profile_user.followees(Store).collect(&:id)  
		following_store_item_ids = @profile_user.followees(StoreItem).collect(&:id)  

		following_store_review_ids = @profile_user.followees(StoreReview).collect(&:id)  

		@user_is_viewing_own_profile = false;
		if current_user.id == @profile_owner_id
			@user_is_viewing_own_profile = true;
		end		
		@active_tab = "feed-link-li"
		
		# we exclude add_comment b/c we pull those in with @storereviewcommentactivities, and we filter it in such a way that each new comment
		# doesn't create a feed item, otherwise, the feed would be flooded.
		# .where("key != ?", "store_review.add_comment")
		@useractivities = PublicActivity::Activity.order("created_at desc").where(owner_id: following_user_ids, owner_type: "User").where("key != ?", "store_review.add_comment")

		@storeactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_ids, trackable_type: "Store")

		@storeitemactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_item_ids, trackable_type: "StoreItem")

		@storereviewcommentactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_review_ids, key: "store_review.add_comment").to_a.uniq{ |row| row.trackable_id }

		# only works well when arrays are equal sizes
		#@activities = @useractivities.zip(@storeactivities).flatten.compact

		@unsortedactivities = @useractivities + @storeactivities + @storeitemactivities + @storereviewcommentactivities
		
		# @useractivities and @storeactivities may return the same activities, but we don't want that in the feed.
		@uniq_activities = @unsortedactivities.uniq

		#	@activities.sort_by(&:created_at)
		@activities = @uniq_activities.sort_by { |obj| obj.created_at }.reverse

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

		@profile_user.create_activity key: 'user.followed', owner: current_user

		respond_to do |format|
			return format.js {}
		end
		
	end

end
