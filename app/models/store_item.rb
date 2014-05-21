class StoreItem < ActiveRecord::Base
	belongs_to :store
	validates :name, presence: true

	STRAINS = ['','indica', 'sativa', 'hybrid']
	validates_inclusion_of :strain, :in => STRAINS,
	      :message => "{{value}} must be in #{STRAINS.join ','}"

	CATEGORIES = ['flower', 'concentrate', 'edible', 'pre-roll', 'other', 'accessory']
	validates_inclusion_of :maincategory, :in => CATEGORIES,
	      :message => "{{value}} must be in #{CATEGORIES.join ','}"

    #weakness: doesn't verify subcategory belongs to parent, we rely on UI to do this logic with linked selects. /shrug
	SUBCATEGORIES = ['bud', 'shake', 'trim',
					 'wax','hash', 'budder/earwar/honeycomb/supermelt', 'bubble hash/full melt/ice wax', 'ISO hash', 'kief/dry sieve', 'shatter/amberglass', 'scissor/finger hash', 'oil/cartridge',
			 		 'baked', 'candy/chocolate', 'cooking', 'drink' , 'frozen', 'other',		
			 		 'blunt', 'joint',
			 		 'clones', 'seeds', 'oral', 'topical',
			 		 'bong/pipe', 'bong/pipe accessories', 'book/magazine', 'butane/lighter', 'cleaning', 'clothes', 'grinder', 'other', 'paper/wrap', 'storage', 'vape', 'vape accessories'		

					]
	validates_inclusion_of :subcategory, :in => SUBCATEGORIES,
	      :message => "{{value}} must be in #{SUBCATEGORIES.join ','}"

	CULTIVATION = ['','indoor', 'outdoor', 'hydroponic', 'greenhouse', 'organic']
	validates_inclusion_of :cultivation, :in => CULTIVATION,
	      :message => "{{value}} must be in #{STRAINS.join ','}"

  	searchable do
    	text     :name, :stored => true
	   	text     :description, :stored => true
	    float    :thc
	    float    :cbd
	    float    :cbn
	    integer  :costhalfgram, :stored => true
	    integer  :costonegram, :stored => true
	    integer  :costeighthoz, :stored => true
	    integer  :costquarteroz, :stored => true
	    integer  :costhalfoz, :stored => true
	    integer  :costoneoz, :stored => true
	    boolean  :dogo
	    #datetime :created_at
	    #datetime :updated_at
	    string   :category, :stored => true
	    integer  :costperunit
	    string   :maincategory
	    string   :strain
	    string   :subcategory
	    string   :cultivation
	    boolean  :privatereserve
	    boolean  :topshelf
	    boolean  :supersize
	    boolean  :glutenfree
	    boolean  :sugarfree
    end


end
