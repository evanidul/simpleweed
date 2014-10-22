class Feed < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	has_many :feed_posts

	def should_generate_new_friendly_id?
    	new_record?
  	end

end
