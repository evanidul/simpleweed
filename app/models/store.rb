class Store < ActiveRecord::Base
	has_many :store_items
	validates :name, presence: true
	# these next two lines cause data:importMenuItems to be really slow.
	# I'm guessing since it creates new stores, it's generating api requests to 
	# geocode all the stores...  Just comment it out and turn it back on later...
	# Comment this back in: rake geocode:all CLASS=Store will not work otherwise
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

		self.dailyspecialsmonday ||= "None."
		self.dailyspecialstuesday ||= "None."
    	self.dailyspecialswednesday ||= "None."
    	self.dailyspecialsthursday ||= "None."
    	self.dailyspecialsfriday ||= "None."
    	self.dailyspecialssaturday ||= "None."
    	self.dailyspecialssunday ||=  "None."

    	self.description ||= "None."		

	    self.announcement ||= "None."
	    self.deliveryarea ||= "None."




	end

	def address
		"#{addressline1}, #{city}, #{state} #{zip}"
	end

end
