class StoreItem < ActiveRecord::Base
	belongs_to :store
	validates :name, presence: true

	STRAINS = ['','indica', 'sativa', 'hybrid']
	validates_inclusion_of :strain, :in => STRAINS,
	      :message => "{{value}} must be in #{STRAINS.join ','}"

	CATEGORIES = ['flower', 'concentrate', 'edible', 'pre-roll', 'other', 'accessory']
	validates_inclusion_of :maincategory, :in => CATEGORIES,
	      :message => "{{value}} must be in #{CATEGORIES.join ','}"

end
