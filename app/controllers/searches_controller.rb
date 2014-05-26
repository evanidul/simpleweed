class SearchesController < ApplicationController

	def create

		@search = Search.new(search_params)

		search = @search
		itemquery = @search.itemsearch
		searchLocation = @search.itemsearch_location
		groupbystore = @search.groupbystore
		filterpriceby = @search.filterpriceby
		pricerangeselect = @search.pricerangeselect
		customminprice = @search.minprice
		custommaxprice = @search.maxprice

		if searchLocation.nil? || searchLocation.empty?
			searchLocation = "la,ca"
		end

		if !itemquery || itemquery.empty?
			redirect_to stores_path(:search => searchLocation )
			return
		end

		if itemquery
			@itemsearch = StoreItem.search do								
				if groupbystore
					group :store_id_str do
						limit 3
					end
				end # if
				paginate :page => 1, :per_page => 100
			  	fulltext itemquery do
					  	highlight :name
					  	highlight :description
					  	highlight :store_name
				end # fulltext
			  
			  
			  geocoordiantes = Geocoder.coordinates(searchLocation);
			  # within 5 kilometers of 34, 118 (LA, CA)
			  case search.distance	  		  	
	  		  	when "city"
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)
	  		  	when "driving"
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 8)
	  		  	when "biking"
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 4)
	  		  	when "walking"
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 2)
	  		  	when "fourblocks"
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 1)
	  		  	else
	  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)
	  		  end


	  		  

	  		  # process strain filters
	  		  #:indica, :sativa, :hybrid, :og, :kush, :haze, :indoor, :outdoor, :hydroponic, :greenhouse, :organic, :privatereserve, :topshelf, :glutenfree, :sugarfree,
	  		  
	  		  acceptable_strains = []
	  		  if search.indica == "true"
	  		  	 acceptable_strains.push("indica")
	  		  end	
	  		  
	  		  if search.sativa == "true"	  		  	
	  		  	acceptable_strains.push("sativa")
	  		  end

			  if search.hybrid == "true"	  		  	
	  		  	acceptable_strains.push("hybrid")
	  		  end
	  		  
			  if !acceptable_strains.empty?
  		  		any_of do 
  		  			with(:strain, acceptable_strains)
  		  			with(:strain, nil)
  		  		end
  		  	  end
	  		  	
	  		  

	  		  #process cultivation
	  		  #:indoor, :outdoor, :hydroponic, :greenhouse, :organic
	  		  #['','indoor', 'outdoor', 'hydroponic', 'greenhouse', 'organic']
	  		  acceptable_cultivation = []
	  		  if search.indoor == "true"
	  		  	acceptable_cultivation.push("indoor")
	  		  end
	  		  if search.outdoor == "true"
	  		  	acceptable_cultivation.push("outdoor")
	  		  end
	  		  if search.hydroponic == "true"
	  		  	acceptable_cultivation.push("hydroponic")
	  		  end
	  		  if search.greenhouse == "true"
	  		  	acceptable_cultivation.push("greenhouse")
	  		  end
	  		  if search.organic == "true"
	  		  	acceptable_cultivation.push("organic")	  		  
	  		  end	  		   		 
	  		  
	  		  if !acceptable_cultivation.empty?
	  		  	any_of do
	  		  		with(:cultivation, acceptable_cultivation)
	  		  		with(:cultivation, nil)
	  		  	end	
	  		  end
	  		  	
	  		  # process misc (strain & attribute)
	  		  if search.privatereserve == "true"
  		  		with(:privatereserve, true)
	  		  end
	  		  if search.topshelf == "true"
	  		  	with(:topshelf, true)
	  		  end
	  		  if search.glutenfree == "true"
				with(:glutenfree, true)
	  		  end
	  		  if search.sugarfree == "true"
	  		  	with(:sugarfree, true)
	  		  end

	  		  # process price filters
	  		  minprice = 0
	  		  maxprice = 1000000

	  		  case pricerangeselect
	  		  	when ""
	  		  	when "custom"
	  		  		minprice = customminprice
	  		  		maxprice = custommaxprice
	  		  	when "lessthan25"
	  		  		maxprice = 25
	  		  	when "between25and50"
	  		  		minprice = 25
	  		  		maxprice = 50
	  		  	when "between50and100"
	  		  		minprice = 50
	  		  		maxprice =100
	  		  	when "between100and200"
	  		  		minprice = 100
	  		  		maxprice = 200
	  		  	when "morethan200"
	  		  		minprice = 200
	  		  end


	  		  case filterpriceby # a_variable is the variable we want to compare
				when ""   				  	 				  
				when "halfgram"    				  	
				  	with(:costhalfgram, minprice..maxprice)
				when "gram"				  	
				  	with(:costonegram, minprice..maxprice)
				when "eighth"					
					with(:costeighthoz, minprice..maxprice)
				when "quarteroz"					
					with(:costquarteroz, minprice..maxprice)
				when "halfoz"						
					with(:costhalfoz, minprice..maxprice)
				when "oz"										
					with(:costoneoz, minprice..maxprice)				
			  end

			  # filter by item category
			  acceptable_item_subcategories = []
			  if search.bud == "true"
			  	acceptable_item_subcategories.push("bud")
			  end
			  if search.shake == "true"
			  	acceptable_item_subcategories.push("shake")
			  end
			  if search.trim == "true"
				acceptable_item_subcategories.push("trim")
			  end
			  if search.wax == "true"
			  	acceptable_item_subcategories.push("wax")
			  end
			  if search.hash == "true"
				acceptable_item_subcategories.push("hash")
			  end
			  if search.budder_earwax_honeycomb == "true"
			  	acceptable_item_subcategories.push("budder/earwar/honeycomb/supermelt")
			  end
			  if search.bubblehash_fullmelt_icewax == "true"
			  	acceptable_item_subcategories.push("bubble hash/full melt/ice wax")
			  end
			  if search.ISOhash == "true"
			  	acceptable_item_subcategories.push("ISO hash")
			  end
			  if search.kief_drysieve == "true"
			  	acceptable_item_subcategories.push("kief/dry sieve")
			  end
			  if search.shatter_amberglass == "true"
			  	acceptable_item_subcategories.push("shatter/amberglass")
			  end
			  if search.scissor_fingerhash == "true"
			  	acceptable_item_subcategories.push("scissor/finger hash")
			  end
			  if search.oil_cartridge == "true"
			  	acceptable_item_subcategories.push("oil/cartridge")
			  end
			  if search.baked == "true"
			  	acceptable_item_subcategories.push("baked")
			  end
			  if search.candy_chocolate == "true"
			  	acceptable_item_subcategories.push("candy/chocolate")
			  end
			  if search.cooking == "true"
			  	acceptable_item_subcategories.push("cooking")
			  end
			  if search.drink == "true"
			  	acceptable_item_subcategories.push("drink")
			  end
			  if search.frozen == "true"
			  	acceptable_item_subcategories.push("frozen")
			  end
			  if search.other_edibles == "true"
			  	acceptable_item_subcategories.push("other")  # minor bug, name collision with "other" since maincategory is not filtered
			  end
			  if search.blunt == "true"
			  	acceptable_item_subcategories.push("blunt")
			  end
			  if search.joint == "true"
			  	acceptable_item_subcategories.push("joint")			  	
			  end
			  if search.clones == "true"
			  	acceptable_item_subcategories.push("clones")			  	
			  end
			  if search.seeds == "true"
			  	acceptable_item_subcategories.push("seeds")			  	
			  end
			  if search.oral == "true"
			  	acceptable_item_subcategories.push("oral")			  	
			  end
			  if search.topical == "true"
			  	acceptable_item_subcategories.push("topical")			  	
			  end
			  if search.bong_pipe == "true"
			  	acceptable_item_subcategories.push("bong/pipe")			  	
			  end
			  if search.bong_pipe_accessories == "true"
			  	acceptable_item_subcategories.push("bong/pipe accessories")			  	
			  end
			  if search.book_magazine == "true"
			  	acceptable_item_subcategories.push("book/magazine")			  	
			  end
			  if search.butane_lighter == "true"
			  	acceptable_item_subcategories.push("butane/lighter")			  	
			  end
			  if search.cleaning == "true"
			  	acceptable_item_subcategories.push("cleaning")			  	
			  end
			  if search.clothes == "true"
			  	acceptable_item_subcategories.push("clothes")			  	
			  end
			  if search.grinder == "true"
			  	acceptable_item_subcategories.push("grinder")			  	
			  end
			  if search.other_accessories == "true"
			  	acceptable_item_subcategories.push("other")			  	
			  end
			  if search.paper_wrap == "true"
			  	acceptable_item_subcategories.push("paper/wrap")			  	
			  end
			  if search.storage == "true"
			  	acceptable_item_subcategories.push("storage")			  	
			  end
			  if search.vape == "true"
			  	acceptable_item_subcategories.push("vape")			  	
			  end
			  if search.vape_accessories == "true"
			  	acceptable_item_subcategories.push("vape accessories")			  	
			  end

	  		  if !acceptable_item_subcategories.empty?
	  		  	any_of do
	  		  		with(:subcategory, acceptable_item_subcategories)
	  		  		with(:subcategory, nil)
	  		  	end	
	  		  end

  			  # filter by store features
			  if search.delivery_service == "true"
			  	with(:store_deliveryservice, true)
			  end
			  if search.accepts_atm_credit == "true"
			  	with(:store_acceptscreditcards, true)
			  end

	  		  # sort by distance
	  		  order_by_geodist(:location, geocoordiantes[0], geocoordiantes[1])

			  

			end # search

			

		end # if

		# loads all the objects from the db?
		#@store_items = @itemsearch.results 
		 @store_items = @itemsearch.hits


		 if groupbystore
		 	render 'search_group_by_store'
		 else 
		 	render 'search'
		 end

	end # end search endpoint	
	

private 
	def search_params
		params.require(:search).permit(
  :itemsearch, :itemsearch_location, :groupbystore, :filterpriceby, :pricerangeselect, :minprice, :maxprice,
  # strain & attributes
  :indica, :sativa, :hybrid, :og, :kush, :haze, :indoor, :outdoor, :hydroponic, :greenhouse, :organic, :privatereserve, :topshelf, :glutenfree, :sugarfree,
  # item type
  :bud, :shake, :trim, :wax, :hash, :budder_earwax_honeycomb,:bubblehash_fullmelt_icewax, :ISOhash, :kief_drysieve, :shatter_amberglass, :scissor_fingerhash, :oil_cartridge, :baked, 
  :candy_chocolate, :cooking, :drink, :frozen, :other_edibles, :blunt, :joint, :clones, :seeds, :oral, :topical,
  :bong_pipe, :bong_pipe_accessories, :book_magazine, :butane_lighter, :cleaning, :clothes, :grinder, :other_accessories, :paper_wrap, 
  :storage, :vape, :vape_accessories,
  # distance
  :distance,
  # store features
  :delivery_service , :accepts_atm_credit, :atm_access, :dispensing_machines, :first_time_patient_deals, :handicap_access, :lounge_area,
  :pet_friendly, :security_guard, :eighteenplus, :twentyplus, :has_photos, :lab_tested, :onsite_testing,
  # lab
  :filterthc_range, :thc_min, :thc_max,
  :filtercbd_range, :cbd_min, :cbd_max,
  :filtercbn_range, :cbn_min, :cbn_max


			)		
	end	

	

end
