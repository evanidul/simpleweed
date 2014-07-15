# dvu: community feeds.  Has nothing to do with profile feeds.
class FeedsController < ApplicationController

	def index
		# @feeds used for top feed nav
		@feeds = Feed.all

		@roleservice = Simpleweed::Security::Roleservice.new
				
		@top_posts_from_today = []
		# TODO: fill this array with top posts from each feed for the current day
		@feeds.each do | feed | 
			# Post.where("created_at >= ?", Time.zone.now.beginning_of_day)
			todays_posts = feed.feed_posts.where("created_at >= ?", Time.zone.now.beginning_of_day)
			todays_most_popular_posts = todays_posts.sort_by {|post| post.sum_votes}.reverse
			for i in 0..3
				if todays_most_popular_posts[i]
					@top_posts_from_today << todays_most_popular_posts[i]
				end
			end

		end
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
		# @feeds used for top feed nav
		@feeds = Feed.all

		# @feed : render the current feed
		@feed = Feed.find(params[:id])
	end 

	private 
	def feed_params
		params.require(:feed).permit(:name)		
	end		

end
