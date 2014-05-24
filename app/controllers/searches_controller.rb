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
	  		  with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)

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
	  		  with(:strain, acceptable_strains)

	  		  

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
