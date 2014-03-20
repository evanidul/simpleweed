class Store < ActiveRecord::Base
	has_many :store_items
	validates :name, presence: true
end
