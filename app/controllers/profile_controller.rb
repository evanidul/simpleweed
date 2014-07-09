class ProfileController < ApplicationController

	before_filter :load_profile_user

	def feed				
		# @profile_owner_id = params[:id].to_i
		# @profile_user = User.find(@profile_owner_id)

		following_user_ids = @profile_user.followees(User).collect(&:id)  

		# always follow yourself
		following_user_ids << current_user.id

		following_store_ids = @profile_user.followees(Store).collect(&:id)  
		following_store_item_ids = @profile_user.followees(StoreItem).collect(&:id)  

		following_store_review_ids = @profile_user.followees(StoreReview).collect(&:id)  

		# @user_is_viewing_own_profile = false;
		# if current_user.id == @profile_owner_id
		# 	@user_is_viewing_own_profile = true;
		# end		
		@active_tab = "feed-link-li"
		
		# we exclude add_comment b/c we pull those in with @storereviewcommentactivities, and we filter it in such a way that each new comment
		# doesn't create a feed item, otherwise, the feed would be flooded.
		# .where("key != ?", "store_review.add_comment")
		@useractivities = PublicActivity::Activity.order("created_at desc").where(owner_id: following_user_ids, owner_type: "User").where("key != ?", "store_review.add_comment")

		@storeactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_ids, trackable_type: "Store")

		@storeitemactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_item_ids, trackable_type: "StoreItem")

		@storeitemreviewactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_item_ids, trackable_type: "StoreItemReview")

		@storereviewcommentactivities = PublicActivity::Activity.order("created_at desc").where(trackable_id: following_store_review_ids, key: "store_review.add_comment").to_a.uniq{ |row| row.trackable_id }

		# only works well when arrays are equal sizes
		#@activities = @useractivities.zip(@storeactivities).flatten.compact

		@unsortedactivities = @useractivities + @storeactivities + @storeitemactivities + @storeitemreviewactivities + @storereviewcommentactivities
		
		# @useractivities and @storeactivities may return the same activities, but we don't want that in the feed.
		@uniq_activities = @unsortedactivities.uniq

		#	@activities.sort_by(&:created_at)
		@activities = @uniq_activities.sort_by { |obj| obj.created_at }.reverse.first(20)

		# store reviews and item reviews must be unique in the feed for the inline forms to work
		uniq_store_review_ids = []
		uniq_item_review_ids = []
		@activities.each do |activity|
			if activity.trackable.is_a? StoreReview
				if uniq_store_review_ids.include? activity.trackable.id
					# remove it					
					@activities.delete(activity)
				else 
					uniq_store_review_ids << activity.trackable.id
				end
			end
			if activity.trackable.is_a? StoreItemReview
				if uniq_item_review_ids.include? activity.trackable.id
					# remove it
					@activities.delete(activity)
				else
					uniq_item_review_ids << activity.trackable.id
				end
			end
			if activity.key == "store.add_review"				
				if uniq_store_review_ids.include? activity.parameters[:store_review_id]
		     		@activities.delete(activity)		     		
		     	else
					uniq_store_review_ids << activity.parameters[:store_review_id]
		     	end
		    end
		end # do
		
	end	

	def activity		
		#current_user = the guy who is viewing the page
		# params[:id] = the owner of the profile
		# @profile_owner_id = params[:id].to_i
		# @profile_user = User.find(@profile_owner_id)
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:id], owner_type: "User").first(20)
		# @user_is_viewing_own_profile = false;
		# if current_user.id == @profile_owner_id
		# 	@user_is_viewing_own_profile = true;
		# end
		@active_tab = "my-activity-li"
		
	end

	# when a user follows another user, this endpoint handles what happens after clicking the star
	def follow

		# @profile_owner_id = params[:id].to_i
		# @profile_user = User.find(@profile_owner_id)
		# # can't follow yourself
		if current_user.id == @profile_owner_id
			return false
		end

		current_user.follow!(@profile_user)

		@profile_user.create_activity key: 'user.followed', owner: current_user

		respond_to do |format|
			return format.js {}
		end
		
	end

	def unfollow
		id_of_person_to_unfollow = params[:id].to_i

		@user_to_unfollow = User.find(id_of_person_to_unfollow)

		if current_user.id == id_of_person_to_unfollow
			return false
		end

		current_user.unfollow!(@user_to_unfollow)

		respond_to do |format|
			return format.js {}
		end

	end

	# when a user wants to see which users he is following
	def followingusers
		@active_tab = "following-link-li"
		@following_users = @profile_user.followees(User)
		
	end

	# when a user wants to see which stores he is following
	def followingstores
		@active_tab = "following-link-li"
		@following_store = @profile_user.followees(Store)  
	end

	# when a user wants to see which items he is following
	def followingitems
		@active_tab = "following-link-li"
		@following_store_items = @profile_user.followees(StoreItem)
	end

private
    def load_profile_user
      	@profile_owner_id = params[:id].to_i
		@profile_user = User.find(@profile_owner_id)
		@user_is_viewing_own_profile = false;
		if current_user.id == @profile_owner_id
			@user_is_viewing_own_profile = true;
		end
    end


end

