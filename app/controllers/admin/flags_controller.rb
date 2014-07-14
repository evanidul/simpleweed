class Admin::FlagsController < ApplicationController

	def index
		@flaggings = Flagging.all
	end

	def destroy	  
	  @user = User.find(flag_params[:flagger_id])
	  @feed_post = FeedPost.find(flag_params[:flaggable_id])

	  @user.unflag(@feed_post)
	 
	   flash[:notice] = "flag has been removed"
	  redirect_to admin_flags_index_path
	end

	private 
	def flag_params
		params.require(:flagging).permit(:id, :flagger_id, :flaggable_id)		
	end		
end
