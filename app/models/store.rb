class Store < ActiveRecord::Base
	has_many :store_items
	validates :name, presence: true
	# these next two lines cause data:importMenuItems to be really slow.
	# I'm guessing since it creates new stores, it's generating api requests to 
	# geocode all the stores...  Just comment it out and turn it back on later...
	# Comment this back in: rake geocode:all CLASS=Store will not work otherwise
	# geocoded_by :address
	# after_validation :geocode

	def address
		"#{addressline1}, #{city}, #{state} #{zip}"
	end

end
