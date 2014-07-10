# dvu: community feeds.  Has nothing to do with profile feeds.
class FeedsController < ApplicationController

	def index
		@feeds = Feed.all
	end

	def new
		render layout: false		
	end

	def create
		@feed = Feed.new(feed_params)
		@feed.save		
		redirect_to feeds_path()
	end

	def show
		@feed = Feed.find(params[:id])
	end 

	private 
	def feed_params
		params.require(:feed).permit(:name)		
	end		

end
