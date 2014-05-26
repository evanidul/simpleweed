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
	  		  if !acceptable_item_subcategories.empty?
	  		  	any_of do
	  		  		with(:subcategory, acceptable_item_subcategories)
	  		  		with(:subcategory, nil)
	  		  	end	
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
