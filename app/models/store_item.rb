class StoreItem < ActiveRecord::Base
	belongs_to :store
	validates :name, presence: true

	STRAINS = ['','indica', 'sativa', 'hybrid']
	validates_inclusion_of :strain, :in => STRAINS,:allow_nil => true,
	      :message => "{{value}} must be in #{STRAINS.join ','}"

	CATEGORIES = ['flower', 'concentrate', 'edible', 'pre-roll', 'other', 'accessory']
	validates_inclusion_of :maincategory, :in => CATEGORIES,:allow_nil => true,
	      :message => "{{value}} must be in #{CATEGORIES.join ','}"

    #weakness: doesn't verify subcategory belongs to parent, we rely on UI to do this logic with linked selects. /shrug
	SUBCATEGORIES = ['bud', 'shake', 'trim',
					 'wax','hash', 'budder/earwar/honeycomb/supermelt', 'bubble hash/full melt/ice wax', 'ISO hash', 'kief/dry sieve', 'shatter/amberglass', 'scissor/finger hash', 'oil/cartridge',
			 		 'baked', 'candy/chocolate', 'cooking', 'drink' , 'frozen', 'other_edible',		
			 		 'blunt', 'joint',
			 		 'clones', 'seeds', 'oral', 'topical',
			 		 'bong/pipe', 'bong/pipe accessories', 'book/magazine', 'butane/lighter', 'cleaning', 'clothes', 'grinder', 'other_accessory', 'paper/wrap', 'storage', 'vape', 'vape accessories'		

					]
	validates_inclusion_of :subcategory, :in => SUBCATEGORIES,:allow_nil => true,
	      :message => "{{value}} must be in #{SUBCATEGORIES.join ','}"

	CULTIVATION = ['','indoor', 'outdoor', 'hydroponic', 'greenhouse']
	validates_inclusion_of :cultivation, :in => CULTIVATION,:allow_nil => true,
	      :message => "{{value}} must be in #{STRAINS.join ','}"

	def location 
		return Sunspot::Util::Coordinates.new(store.latitude, store.longitude)
	end

  	searchable do
  		integer  :id, :stored => true
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
	    boolean  :organic

	    boolean  :og
	    boolean  :kush
	    boolean  :haze

	    integer :store_id, :stored => true
	    string(:store_id_str) { |p| p.store.id.to_s }
	    
	    # store info	   
	    # NOTE, store id is fetched above

	    text :store_name , :stored => true do
		   store.name 
	  	end

	    text :store_addressline1 , :stored => true do
		   store.addressline1
	  	end

	    text :store_addressline2 , :stored => true do
		   store.addressline2
	  	end

	    text :store_city , :stored => true do
		   store.city
	  	end
	  	
		text :store_state , :stored => true do
		   store.state
	  	end	  	
	  	text :store_zip , :stored => true do
		   store.zip
	  	end

	  	text :store_phonenumber , :stored => true do
		   store.phonenumber
	  	end
	  	
	  	latlon :location, :stored => true
	  	float :store_latitude, :stored => true do
	  		store.latitude
	  	end
	  	float :store_longitude, :stored => true do
	  		store.longitude
	  	end

	  	# store features
	  	boolean :store_deliveryservice, :stored => true do
	  		store.deliveryservice
	  	end
	  	boolean :store_acceptscreditcards, :stored => true do
	  		store.acceptscreditcards
	  	end
	  	boolean :store_atmaccess, :stored => true do
	  		store.atmaccess
	  	end
	  	boolean :store_automaticdispensingmachines, :stored => true do
	  		store.automaticdispensingmachines
	  	end

	  	boolean :store_firsttimepatientdeals, :stored => true do
	  		store.firsttimepatientdeals
	  	end
	  	boolean :store_handicapaccess, :stored => true do
	  		store.handicapaccess
	  	end
	  	boolean :store_loungearea, :stored => true do
	  		store.loungearea
	  	end
	  	boolean :store_petfriendly, :stored => true do
	  		store.petfriendly
	  	end

	  	boolean :store_securityguard, :stored => true do
	  		store.securityguard
	  	end
	  	boolean :store_eighteenplus, :stored => true do
	  		store.eighteenplus
	  	end
	  	boolean :store_twentyoneplus, :stored => true do
	  		store.twentyoneplus
	  	end
	  	boolean :store_hasphotos, :stored => true do
	  		store.hasphotos
	  	end
	  	boolean :store_labtested, :stored => true do
	  		store.labtested
	  	end
	  	boolean :store_onsitetesting, :stored => true do
	  		store.onsitetesting
	  	end

    end


end
