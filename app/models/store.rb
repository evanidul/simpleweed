class Store < ActiveRecord::Base
	has_many :store_items
	validates :name, presence: true
	geocoded_by :address
	after_validation :geocode

	def address
		"#{addressline1}, #{city}, #{state} #{zip}"
	end

end
