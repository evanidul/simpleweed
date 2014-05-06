class Store < ActiveRecord::Base
	has_many :store_items
	validates :name, presence: true
	# these next two lines cause data:importMenuItems to be really slow.
	# I'm guessing since it creates new stores, it's generating api requests to 
	# geocode all the stores...  Just comment it out and turn it back on later...
	# Comment this back in: rake geocode:all CLASS=Store will not work otherwise
	geocoded_by :address
	after_validation :geocode
	after_initialize :init

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

    	self.description ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse bibendum tempus est quis sollicitudin. Nulla eu nulla sit amet odio aliquam imperdiet vel sed metus. Ut consequat, augue ac tincidunt accumsan, nisi lacus egestas nisl, nec rhoncus quam leo ut est. Pellentesque pretium, tortor molestie placerat consectetur, mauris elit hendrerit risus, feugiat rutrum lorem metus vel ipsum. Vivamus interdum pharetra nunc, sed ullamcorper neque facilisis non. Vestibulum vitae pellentesque nibh, ac ornare ante. Aenean consectetur dapibus dui, nec adipiscing nulla blandit eu. Pellentesque sit amet dapibus est, quis cursus nunc. Vivamus justo est, pulvinar ac eleifend vitae, faucibus vitae turpis."
		self.firsttimepatientdeals ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse bibendum tempus est quis sollicitudin. "

	    self.storehourssunday ||= "None set"
	    self.storehoursmonday ||= "None set"
	    self.storehourstuesday ||= "None set"
	    self.storehourswednesday ||= "None set"
	    self.storehoursthursday ||= "None set"
	    self.storehoursfriday ||= "None set"
	    self.storehourssaturday ||= "None set"

	    self.announcement ||= "None."
	    self.deliveryarea ||= "None."




	end

	def address
		"#{addressline1}, #{city}, #{state} #{zip}"
	end

end
