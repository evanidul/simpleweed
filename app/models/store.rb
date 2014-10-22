class Store < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: [:slugged, :finders]

	has_many :store_items
	has_many :store_reviews
	has_many :cancellations

	include PublicActivity::Common    
    #tracked        
    # omitting 'tracked' seems to let us fire custom events in the controller whenever the store is being edited, instead of
    # tracking any updates to the store.

	# a store may be followed
	acts_as_followable
	
	validates :name, presence: true
	# these next two lines cause data:importMenuItems to be really slow.
	# I'm guessing since it creates new stores, it's generating api requests to 
	# geocode all the stores...  Just comment it out and turn it back on later...
	# Comment this back in: rake geocode:all CLASS=Store will not work otherwise
	# Unit tests will also fail if this is commented out.
	# SEL tests will also fail, since stores won't have lat/long, therefore no items from that store will be in search index
	geocoded_by :address
	after_validation :geocode

	# init default values
	after_initialize :init

	# dvu: used for rollify?
	resourcify

	def init
		self.addressline1 ||= "500 Montgomery St."
    	self.city ||= "San Francisco"
    	self.state ||= "CA"
    	self.zip ||= "94705"
    	self.phonenumber ||= "1 (415) GHOSTBUSTERS"

		self.dailyspecialsmonday ||= "none."
		self.dailyspecialstuesday ||= "none."
    	self.dailyspecialswednesday ||= "none."
    	self.dailyspecialsthursday ||= "none."
    	self.dailyspecialsfriday ||= "none."
    	self.dailyspecialssaturday ||= "none."
    	self.dailyspecialssunday ||=  "none."

    	self.description ||= "none."		

	    self.announcement ||= "none."
	    self.deliveryarea ||= "none."




	end

	def address
		"#{addressline1}, #{city}, #{state} #{zip}"
	end

	# slug only gets created on new, not on updates to name
	# http://railscasts.com/episodes/314-pretty-urls-with-friendlyid?view=asciicast
	# comment this out for first Store.find_each(&:save), import
	def should_generate_new_friendly_id?
    	new_record?
  	end

end
