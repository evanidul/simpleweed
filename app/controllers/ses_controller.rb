class SesController < ApplicationController

	def index

		@search = Se.new(search_params)

		search = @search
		itemquery = @search.itemsearch
		searchLocation = @search.isl
		groupbystore = @search.gbs
		filterpriceby = @search.fpb
		pricerangeselect = @search.prs
		customminprice = @search.mp
		custommaxprice = @search.xp

		if searchLocation.nil? || searchLocation.empty?
			searchLocation = "la,ca"
		end

		# if !itemquery || itemquery.empty?			
		# 	redirect_to stores_path(:search => searchLocation )
		# 	return
		# end
		geocoordiantes = Geocoder.coordinates(searchLocation);
		  if !geocoordiantes
		  	# they typed in gibberish for search coordinates
		  	
		  	@store_items = []		  			  	
		  	render 'search'
		  	return
		  end 
		
		@itemsearch = StoreItem.search do								
			paginate :page => 1, :per_page => 100
			if !itemquery || itemquery.empty?			
				group :store_id_str do
					limit 3
				end # group
				# fulltext "og" do
				#   	highlight :name
				#   	highlight :description
				#   	highlight :store_name
				# end # fulltext				
				@itemcollapsed = true; # tell the view not to show the items			

			end # if
			
			if itemquery
		  		fulltext itemquery do
				  	highlight :name
				  	highlight :description
				  	highlight :store_name
				end # fulltext
		    end # if

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
  		  if search.o == "1"
  		  	 acceptable_strains.push("indica")
  		  end	
  		  
  		  if search.p == "1"	  		  	
  		  	acceptable_strains.push("sativa")
  		  end

		  if search.q == "1"	  		  	
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
  		  if search.u == "1"
  		  	acceptable_cultivation.push("indoor")
  		  end
  		  if search.v == "1"
  		  	acceptable_cultivation.push("outdoor")
  		  end
  		  if search.w == "1"
  		  	acceptable_cultivation.push("hydroponic")
  		  end
  		  if search.x == "1"
  		  	acceptable_cultivation.push("greenhouse")
  		  end
  		  if search.y == "1"
  		  	acceptable_cultivation.push("organic")	  		  
  		  end	  		   		 
  		  
  		  if !acceptable_cultivation.empty?
  		  	any_of do
  		  		with(:cultivation, acceptable_cultivation)
  		  		with(:cultivation, nil)
  		  	end	
  		  end
  		  	
  		  # process misc (strain & attribute)
  		  if search.z == "1"
		  		with(:privatereserve, true)
  		  end
  		  if search.aa == "1"
  		  	with(:topshelf, true)
  		  end
  		  if search.bb == "1"
			with(:glutenfree, true)
  		  end
  		  if search.cc == "1"
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
		  if search.i1 == "1"
		  	acceptable_item_subcategories.push("bud")
		  end
		  if search.i2 == "1"
		  	acceptable_item_subcategories.push("shake")
		  end
		  if search.i3 == "1"
			acceptable_item_subcategories.push("trim")
		  end
		  if search.i4 == "1"
		  	acceptable_item_subcategories.push("wax")
		  end
		  if search.i5 == "1"
			acceptable_item_subcategories.push("hash")
		  end
		  if search.i6 == "1"
		  	acceptable_item_subcategories.push("budder/earwar/honeycomb/supermelt")
		  end
		  if search.i7 == "1"
		  	acceptable_item_subcategories.push("bubble hash/full melt/ice wax")
		  end
		  if search.i8 == "1"
		  	acceptable_item_subcategories.push("ISO hash")
		  end
		  if search.i9 == "1"
		  	acceptable_item_subcategories.push("kief/dry sieve")
		  end
		  if search.i10 == "1"
		  	acceptable_item_subcategories.push("shatter/amberglass")
		  end
		  if search.i11 == "1"
		  	acceptable_item_subcategories.push("scissor/finger hash")
		  end
		  if search.i12 == "1"
		  	acceptable_item_subcategories.push("oil/cartridge")
		  end
		  if search.i13 == "1"
		  	acceptable_item_subcategories.push("baked")
		  end
		  if search.i14 == "1"
		  	acceptable_item_subcategories.push("candy/chocolate")
		  end
		  if search.i15 == "1"
		  	acceptable_item_subcategories.push("cooking")
		  end
		  if search.i16 == "1"
		  	acceptable_item_subcategories.push("drink")
		  end
		  if search.i17 == "1"
		  	acceptable_item_subcategories.push("frozen")
		  end
		  if search.i18 == "1"
		  	acceptable_item_subcategories.push("other")  # minor bug, name collision with "other" since maincategory is not filtered
		  end
		  if search.i19 == "1"
		  	acceptable_item_subcategories.push("blunt")
		  end
		  if search.i20 == "1"
		  	acceptable_item_subcategories.push("joint")			  	
		  end
		  if search.i21 == "1"
		  	acceptable_item_subcategories.push("clones")			  	
		  end
		  if search.i22 == "1"
		  	acceptable_item_subcategories.push("seeds")			  	
		  end
		  if search.i23 == "1"
		  	acceptable_item_subcategories.push("oral")			  	
		  end
		  if search.i24 == "1"
		  	acceptable_item_subcategories.push("topical")			  	
		  end
		  if search.i25 == "1"
		  	acceptable_item_subcategories.push("bong/pipe")			  	
		  end
		  if search.i26 == "1"
		  	acceptable_item_subcategories.push("bong/pipe accessories")			  	
		  end
		  if search.i27 == "1"
		  	acceptable_item_subcategories.push("book/magazine")			  	
		  end
		  if search.i28 == "1"
		  	acceptable_item_subcategories.push("butane/lighter")			  	
		  end
		  if search.i29 == "1"
		  	acceptable_item_subcategories.push("cleaning")			  	
		  end
		  if search.i30 == "1"
		  	acceptable_item_subcategories.push("clothes")			  	
		  end
		  if search.i31 == "1"
		  	acceptable_item_subcategories.push("grinder")			  	
		  end
		  if search.i32 == "1"
		  	acceptable_item_subcategories.push("other")			  	
		  end
		  if search.i33 == "1"
		  	acceptable_item_subcategories.push("paper/wrap")			  	
		  end
		  if search.i34 == "1"
		  	acceptable_item_subcategories.push("storage")			  	
		  end
		  if search.i35 == "1"
		  	acceptable_item_subcategories.push("vape")			  	
		  end
		  if search.i36 == "1"
		  	acceptable_item_subcategories.push("vape accessories")			  	
		  end

  		  if !acceptable_item_subcategories.empty?
  		  	any_of do
  		  		with(:subcategory, acceptable_item_subcategories)
  		  		with(:subcategory, nil)
  		  	end	
  		  end

			  # filter by store features
		  if search.a == "1"
		  	with(:store_deliveryservice, true)
		  end
		  if search.b == "1"
		  	with(:store_acceptscreditcards, true)
		  end
		  if search.c == "1"
		  	with(:store_atmaccess, true)
		  end
		  if search.d == "1"
		  	with(:store_automaticdispensingmachines, true)
		  end
		  if search.e == "1"
		  	with(:store_firsttimepatientdeals, true)
		  end
		  if search.f == "1"
		  	with(:store_handicapaccess, true)
		  end
		  if search.g == "1"
		  	with(:store_loungearea, true)
		  end
		  if search.h == "1"
		  	with(:store_petfriendly, true)
		  end
		  if search.i == "1"
		  	with(:store_securityguard, true)
		  end
		  if search.j == "1"
		  	with(:store_eighteenplus, true)
		  end
		  if search.k == "1"
		  	with(:store_twentyoneplus, true)
		  end
		  if search.l == "1"
		  	with(:store_hasphotos, true)
		  end
		  if search.m == "1"
		  	with(:store_labtested, true)
		  end
		  if search.n == "1"
		  	with(:store_onsitetesting, true)
		  end

		  # filter lab
		  case search.filterthc_range
  		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:thc, 0..5.0)
		    		with(:thc, nil)
		    	end
		    when "between5and10"
		    	with(:thc, 5.0..10.0)
		    when "between10-25"
		    	with(:thc, 10.0..25.0)	
		    when "between25and50"
		    	with(:thc, 25.0..50.0)	
		    when "morethan50"
		    	with(:thc).greater_than(50.0)
		    else
		  end

		  case search.filtercbd_range
		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:cbd, 0..5.0)
		    		with(:cbd, nil)
		    	end
		    when "between5and10"
		    	with(:cbd, 5.0..10.0)	
	    	when "between10-25"
		    	with(:cbd, 10.0..25.0)	
		    when "between25and50"	
		    	with(:cbd, 25.0..50.0)	
		    when "morethan50"
		    	with(:cbd).greater_than(50.0)	
		    else
	      end

		  case search.filtercbn_range
		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:cbn, 0..5.0)
		    		with(:cbn, nil)
		    	end
		    when "between5and10"
		    	with(:cbn, 5.0..10.0)	
		    when "between10-25"
		    	with(:cbn, 10.0..25.0)
			when "between25and50"	
		    	with(:cbn, 25.0..50.0)	
		    when "morethan50"
		    	with(:cbn).greater_than(50.0)
		    else		
	      end
  		  # sort by distance
  		  order_by_geodist(:location, geocoordiantes[0], geocoordiantes[1])						 

		end # search

			

		

		# loads all the objects from the db?
		#@store_items = @itemsearch.results 
		 @store_items = @itemsearch.hits


		 if !itemquery || itemquery.empty?			
		 	render 'search_group_by_store'
		 else 
		 	render 'search'
		 end

	end # end search endpoint	
	

private 
	def search_params
		params.require(:se).permit(
  :itemsearch, #:itemsearch, 
  :isl, #:itemsearch_location, 
  :gbs, #:groupbystore, 

  :fpb,  #:filterpriceby, 
  :prs, #:pricerangeselect, 
  :mp, #:minprice, 
  :xp, #:maxprice,
  
  
  # strain & attributes
  :o, #:indica
  :p, #:sativa
  :q, #:hybrid
  :r, #:og
  :s, #:kush
  :t, #:haze
  :u, #:indoor
  :v, #:outdoor
  :w, #:hydroponic
  :x, #:greenhouse
  :y, #:organic, 
  :z, #:privatereserve
  :aa, #:topshelf, 
  :bb, #:glutenfree, 
  :cc, #:sugarfree,

  # item type
  :i1, #:bud 
  :i2, #:shake 
  :i3, #:trim
  :i4, #:wax 
  :i5, #:hash
  :i6, #:budder_earwax_honeycomb
  :i7, #:bubblehash_fullmelt_icewax, 
  :i8, #:ISOhash
  :i9, #:kief_drysieve, 
  :i10, #:shatter_amberglass, 
  :i11, #:scissor_fingerhash, 
  :i12, #:oil_cartridge, 
  :i13, #:baked, 
  :i14, #:candy_chocolate
  :i15, #:cooking
  :i16, #:drink
  :i17, #:frozen
  :i18, #:other_edibles, 
  :i19, #:blunt, 
  :i20, #:joint
  :i21, #:clones
  :i22, #:seeds
  :i23, #:oral
  :i24,  #:topical,
  :i25, #:bong_pipe
  :i26, #:bong_pipe_accessories
  :i27, #:book_magazine
  :i28, #:butane_lighter
  :i29, #:cleaning
  :i30, #:clothes
  :i31, #:grinder
  :i32, #:other_accessories
  :i33, #:paper_wrap 
  :i34, #:storage
  :i35, #:vape
  :i36, #:vape_accessories,
  # distance
  :distance,
  

  # store features
  :a, #:delivery_service , 
  :b, #:accepts_atm_credit,
  :c, # :atm_access, 
  :d, #:dispensing_machines, 
  :e, #:first_time_patient_deals, 
  :f, #:handicap_access, 
  :g, #:lounge_area,
  :h, #:pet_friendly, 
  :i, #:security_guard, 
  :j, #:eighteenplus, 
  :k, #:twentyplus, 
  :l, #:has_photos, 
  :m, #:lab_tested, 
  :n, #:onsite_testing,

  # lab
  :filterthc_range, :thc_min, :thc_max,
  :filtercbd_range, :cbd_min, :cbd_max,
  :filtercbn_range, :cbn_min, :cbn_max


			)		
	end	

	

end
