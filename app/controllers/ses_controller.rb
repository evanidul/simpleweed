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

		# searchbadges get shown in the search results so that the user is aware of which attributes are filtered on
		searchbadges = []

		@itemcollapsed = false
		if !itemquery || itemquery.empty?			
			@itemcollapsed = true
		end
		if groupbystore
			@itemcollapsed = false
		end

		# if !itemquery || itemquery.empty?			
		# 	redirect_to stores_path(:search => searchLocation )
		# 	return
		# end
		geocoordiantes = Geocoder.coordinates(searchLocation);
		  if !geocoordiantes
		  	# they typed in gibberish for search coordinates
		  	
		  	@store_items = []	
		  	@isLastPage = true	  			  	
		  	render 'search'
		  	return
		  end 
		
		@itemsearch = StoreItem.search do											
			if search.pg
				if search.pg.empty?
					search.pg = 1
				end
				paginate :page => search.pg, :per_page => 100				
				search.pg = search.pg.to_i + 1				
			# else
			# 	binding.pry
			# 	paginate :page => 1, :per_page => 100
			# 	search.pg = search.pg + 1
			end

			if !itemquery || itemquery.empty? || groupbystore
				group :store_id_str do
					limit 7
				end # group
				# fulltext "og" do
				#   	highlight :name
				#   	highlight :description
				#   	highlight :store_name
				# end # fulltext				
				#@itemcollapsed = true; # tell the view not to show the items			

			end # if
			
			if itemquery
		  		fulltext itemquery do
				  	highlight :name
				  	highlight :description
				  	highlight :store_name
				  	highlight :promo
				end # fulltext
		    end # if

		  # within 5 kilometers of 34, 118 (LA, CA)
		  case search.di
  		  	when "c"
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)
  		  		searchbadges.push("within city limits")
  		  	when "d"
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 8)
  		  		searchbadges.push("within driving distance")
  		  	when "b"
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 4)
  		  		searchbadges.push("within biking distance")
  		  	when "w"
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 2)
  		  		searchbadges.push("within walking distance")
  		  	when "f"
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 1)
  		  		searchbadges.push("within 4 blocks")
  		  	else
  		  		with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)
  		  end


  		  

  		  # process strain filters
  		  #:indica, :sativa, :hybrid, :og, :kush, :haze, :indoor, :outdoor, :hydroponic, :greenhouse, :organic, :privatereserve, :topshelf, :glutenfree, :sugarfree,
  		  
  		  acceptable_strains = []
  		  if search.o == "1"
  		  	 acceptable_strains.push("indica")
  		  	 searchbadges.push("indica")
  		  end	
  		  
  		  if search.p == "1"	  		  	
  		  	acceptable_strains.push("sativa")
  		  	searchbadges.push("sativa")
  		  end

		  if search.q == "1"	  		  	
  		  	acceptable_strains.push("hybrid")
  		  	searchbadges.push("hybrid")
  		  end
  		  
		  if !acceptable_strains.empty?
		  		any_of do 
		  			with(:strain, acceptable_strains)
		  			#with(:strain, nil)
		  		end
		  	  end
  		  
  		  # process popular	
  		  #:r, :og
  		  if search.r == "1"
	  		with(:og, true)
	  		searchbadges.push("og")
  		  end
  		  #:s, :kush
		  if search.s == "1"
	  		with(:kush, true)
	  		searchbadges.push("kush")
  		  end
  		  #:t, :haze
		  if search.t == "1"
	  		with(:haze, true)
	  		searchbadges.push("haze")
  		  end

  		  #process cultivation
  		  #:indoor, :outdoor, :hydroponic, :greenhouse, :organic
  		  #['','indoor', 'outdoor', 'hydroponic', 'greenhouse', 'organic']
  		  acceptable_cultivation = []
  		  if search.u == "1"
  		  	acceptable_cultivation.push("indoor")
  		  	searchbadges.push("indoor")
  		  end
  		  if search.v == "1"
  		  	acceptable_cultivation.push("outdoor")
  		  	searchbadges.push("outdoor")
  		  end
  		  if search.w == "1"
  		  	acceptable_cultivation.push("hydroponic")
  		  	searchbadges.push("hydroponic")
  		  end
  		  if search.x == "1"
  		  	acceptable_cultivation.push("greenhouse")
  		  	searchbadges.push("greenhouse")
  		  end  		  
  		  
  		  if !acceptable_cultivation.empty?
  		  	any_of do
  		  		with(:cultivation, acceptable_cultivation)
  		  		#with(:cultivation, nil)
  		  	end	
  		  end
  		  	
  		  # process misc (strain & attribute)
  		  if search.z == "1"
	  		with(:privatereserve, true)
	  		searchbadges.push("private reserve")
  		  end
  		  if search.aa == "1"
  		  	with(:topshelf, true)
  		  	searchbadges.push("top shelf")
  		  end
  		  if search.bb == "1"
			with(:glutenfree, true)
			searchbadges.push("gluten free")
  		  end
  		  if search.cc == "1"
  		  	with(:sugarfree, true)
  		  	searchbadges.push("sugar free")
  		  end
		  if search.y == "1"
  		  	with(:organic, true)	  	
  		  	searchbadges.push("organic")	  
  		  end	  		   		 

  		  # process price filters
  		  minprice = 0
  		  maxprice = 1000000

  		  case pricerangeselect
  		  	when ""
  		  	when "custom"
  		  		minprice = customminprice
  		  		maxprice = custommaxprice
  		  		searchbadges.push(customminprice + " > price < " + custommaxprice)	  
  		  	when "lessthan25"
  		  		maxprice = 25
  		  		searchbadges.push("price < 25")	  
  		  	when "between25and50"
  		  		minprice = 25
  		  		maxprice = 50
  		  		searchbadges.push("25 > price < 50")	  
  		  	when "between50and100"
  		  		minprice = 50
  		  		maxprice =100
  		  		searchbadges.push("50 > price < 100")	 
  		  	when "between100and200"
  		  		minprice = 100
  		  		maxprice = 200
  		  		searchbadges.push("100 > price < 200")	 
  		  	when "morethan200"
  		  		minprice = 200
  		  		searchbadges.push("price > 200")	 
  		  end

  		  if search.dd == "1"
  		  	with(:supersize, true)	  		  
  		  	searchbadges.push("supersize")	 
  		  end	  		   		 
  		  if search.ee == "1"
  		  	with(:dogo, true)	 
  		  	searchbadges.push("bogo")	  		  
  		  end	  		   		 

  		  case filterpriceby # a_variable is the variable we want to compare
			when ""   				  	 				  
			when "halfgram"    				  	
			  	with(:costhalfgram, minprice..maxprice)
			  	searchbadges.push("half gram price")	  		  
			when "gram"				  	
			  	with(:costonegram, minprice..maxprice)
			  	searchbadges.push("gram price")	  		  
			when "eighth"					
				with(:costeighthoz, minprice..maxprice)
				searchbadges.push("eighth price")	  		  
			when "quarteroz"					
				with(:costquarteroz, minprice..maxprice)
				searchbadges.push("quarter oz price")	  		  
			when "halfoz"						
				with(:costhalfoz, minprice..maxprice)
				searchbadges.push("half oz price")	  		  
			when "oz"										
				with(:costoneoz, minprice..maxprice)				
				searchbadges.push("oz price")	  		  
		  end

		  # filter by item category
		  acceptable_item_subcategories = []
		  if search.i1 == "1"
		  	acceptable_item_subcategories.push("bud")
		  	searchbadges.push("bud")	  		  
		  end
		  if search.i2 == "1"
		  	acceptable_item_subcategories.push("shake")
		  	searchbadges.push("shake")
		  end
		  if search.i3 == "1"
			acceptable_item_subcategories.push("trim")
			searchbadges.push("trim")
		  end
		  if search.i4 == "1"
		  	acceptable_item_subcategories.push("wax")
		  	searchbadges.push("wax")
		  end
		  if search.i5 == "1"
			acceptable_item_subcategories.push("hash")
			searchbadges.push("hash")
		  end
		  if search.i6 == "1"
		  	acceptable_item_subcategories.push("budder/earwax/honeycomb/supermelt")
		  	searchbadges.push("budder/earwax/honeycomb/supermelt")
		  end
		  if search.i7 == "1"
		  	acceptable_item_subcategories.push("bubble hash/full melt/ice wax")
		  	searchbadges.push("bubble hash/full melt/ice wax")
		  end
		  if search.i8 == "1"
		  	acceptable_item_subcategories.push("iso hash")
		  	searchbadges.push("iso hash")
		  end
		  if search.i9 == "1"
		  	acceptable_item_subcategories.push("kief/dry sieve")
		  	searchbadges.push("kief/dry sieve")
		  end
		  if search.i10 == "1"
		  	acceptable_item_subcategories.push("shatter/amberglass")
		  	searchbadges.push("shatter/amberglass")
		  end
		  if search.i11 == "1"
		  	acceptable_item_subcategories.push("scissor/finger hash")
		  	searchbadges.push("scissor/finger hash")
		  end
		  if search.i12 == "1"
		  	acceptable_item_subcategories.push("oil/cartridge")
		  	searchbadges.push("oil/cartridge")
		  end
		  if search.i13 == "1"
		  	acceptable_item_subcategories.push("baked")
		  	searchbadges.push("baked")
		  end
		  if search.i14 == "1"
		  	acceptable_item_subcategories.push("candy/chocolate")
		  	searchbadges.push("candy/chocolate")
		  end
		  if search.i15 == "1"
		  	acceptable_item_subcategories.push("cooking")
		  	searchbadges.push("cooking")
		  end
		  if search.i16 == "1"
		  	acceptable_item_subcategories.push("drink")
		  	searchbadges.push("drink")
		  end
		  if search.i17 == "1"
		  	acceptable_item_subcategories.push("frozen")
		  	searchbadges.push("frozen")
		  end
		  if search.i18 == "1"
		  	acceptable_item_subcategories.push("other_edible")  # minor bug, name collision with "other" since maincategory is not filtered
		  	searchbadges.push("other edibles")
		  end
		  if search.i19 == "1"
		  	acceptable_item_subcategories.push("blunt")
		  	searchbadges.push("blunt")
		  end
		  if search.i20 == "1"
		  	acceptable_item_subcategories.push("joint")			  	
		  	searchbadges.push("joint")
		  end
		  if search.i21 == "1"
		  	acceptable_item_subcategories.push("clones")			  	
		  	searchbadges.push("clones")
		  end
		  if search.i22 == "1"
		  	acceptable_item_subcategories.push("seeds")	
		  	searchbadges.push("seeds")		  	
		  end
		  if search.i23 == "1"
		  	acceptable_item_subcategories.push("oral")			  	
		  	searchbadges.push("oral")		  	
		  end
		  if search.i24 == "1"
		  	acceptable_item_subcategories.push("topical")			  	
		  	searchbadges.push("topical")		  	
		  end
		  if search.i25 == "1"
		  	acceptable_item_subcategories.push("bong/pipe")			  	
		  	searchbadges.push("bong/pipe")		  	
		  end
		  if search.i26 == "1"
		  	acceptable_item_subcategories.push("bong/pipe accessories")			  	
		  	searchbadges.push("bong/pipe accessories")		  	
		  end
		  if search.i27 == "1"
		  	acceptable_item_subcategories.push("book/magazine")	
		  	searchbadges.push("book/magazine")		  	
		  end
		  if search.i28 == "1"
		  	acceptable_item_subcategories.push("butane/lighter")
		  	searchbadges.push("butane/lighter")		  				  	
		  end
		  if search.i29 == "1"
		  	acceptable_item_subcategories.push("cleaning")	
		  	searchbadges.push("cleaning")		  				  			  	
		  end
		  if search.i30 == "1"
		  	acceptable_item_subcategories.push("clothes")			  	
		  	searchbadges.push("clothes")		  				 
		  end
		  if search.i31 == "1"
		  	acceptable_item_subcategories.push("grinder")			  	
		  	searchbadges.push("grinder")		  				 
		  end
		  if search.i32 == "1"
		  	acceptable_item_subcategories.push("other_accessory")			  	
		  	searchbadges.push("other accessories")		  				 
		  end
		  if search.i33 == "1"
		  	acceptable_item_subcategories.push("paper/wrap")			  	
		  	searchbadges.push("paper/wrap")
		  end
		  if search.i34 == "1"
		  	acceptable_item_subcategories.push("storage")			  	
		  	searchbadges.push("storage")
		  end
		  if search.i35 == "1"
		  	acceptable_item_subcategories.push("vape")			  
		  	searchbadges.push("vape")	
		  end
		  if search.i36 == "1"
		  	acceptable_item_subcategories.push("vape accessories")			  	
		  	searchbadges.push("vape accessories")
		  end

  		  if !acceptable_item_subcategories.empty?
  		  	any_of do
  		  		with(:subcategory, acceptable_item_subcategories)
  		  		#with(:subcategory, nil)
  		  	end	
  		  end

			  # filter by store features
		  if search.a == "1"
		  	with(:store_deliveryservice, true)
		  	searchbadges.push("delivery service")	
		  end
		  if search.b == "1"
		  	with(:store_acceptscreditcards, true)
		  	searchbadges.push("accepts atm/credit")	
		  end
		  if search.c == "1"
		  	with(:store_atmaccess, true)
		  	searchbadges.push("atm access")	
		  end
		  if search.d == "1"
		  	with(:store_automaticdispensingmachines, true)
		  	searchbadges.push("automatic dispensing machines")	
		  end
		  if search.e == "1"
		  	with(:store_firsttimepatientdeals, true)
		  	searchbadges.push("first time patient deals")	
		  end
		  if search.f == "1"
		  	with(:store_handicapaccess, true)
		  	searchbadges.push("handicap access")	
		  end
		  if search.g == "1"
		  	with(:store_loungearea, true)
		  	searchbadges.push("lounge area")	
		  end
		  if search.h == "1"
		  	with(:store_petfriendly, true)
		  	searchbadges.push("pet friendly")	
		  end
		  if search.i == "1"
		  	with(:store_securityguard, true)
		  	searchbadges.push("security guard")	
		  end
		  if search.j == "1"
		  	with(:store_eighteenplus, true)
		  	searchbadges.push("eighteen plus")	
		  end
		  if search.k == "1"
		  	with(:store_twentyoneplus, true)
		  	searchbadges.push("twentyone plus")	
		  end
		  if search.l == "1"
		  	with(:store_hasphotos, true)
		  	searchbadges.push("has photos")	
		  end
		  if search.m == "1"
		  	with(:store_labtested, true)
		  	searchbadges.push("lab tested")	
		  end
		  if search.n == "1"
		  	with(:store_onsitetesting, true)
		  	searchbadges.push("onsite testing")	
		  end

		  # filter lab
		  case search.filterthc_range
  		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:thc, 0..5.0)
		    		with(:thc, nil)
		    		searchbadges.push("thc < 5%")	
		    	end
		    when "between5and10"
		    	with(:thc, 5.0..10.0)
		    	searchbadges.push("5% < thc < 10%")	
		    when "between10-25"
		    	with(:thc, 10.0..25.0)	
		    	searchbadges.push("10% < thc < 25%")	
		    when "between25and50"
		    	with(:thc, 25.0..50.0)	
		    	searchbadges.push("25% < thc < 50%")	
		    when "morethan50"
		    	with(:thc).greater_than(50.0)
		    	searchbadges.push("thc > 50%")	
		    else
		  end

		  case search.filtercbd_range
		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:cbd, 0..5.0)
		    		with(:cbd, nil)
		    		searchbadges.push("cbd < 5%")	
		    	end
		    when "between5and10"
		    	with(:cbd, 5.0..10.0)	
		    	searchbadges.push("5% < cbd < 10%")	
	    	when "between10-25"
		    	with(:cbd, 10.0..25.0)	
		    	searchbadges.push("10% < cbd < 25%")	
		    when "between25and50"	
		    	with(:cbd, 25.0..50.0)	
		    	searchbadges.push("25% < cbd < 50%")	
		    when "morethan50"
		    	with(:cbd).greater_than(50.0)	
		    	searchbadges.push("cbd > 50%")	
		    else
	      end

		  case search.filtercbn_range
		  	when ""
		    when "lessthan5"
		    	any_of do 
		    		with(:cbn, 0..5.0)
		    		with(:cbn, nil)
		    		searchbadges.push("cbn < 5%")
		    	end
		    when "between5and10"
		    	with(:cbn, 5.0..10.0)	
		    	searchbadges.push("5% < cbn < 10%")	
		    when "between10-25"
		    	with(:cbn, 10.0..25.0)
		    	searchbadges.push("10% < cbn < 25%")
			when "between25and50"	
		    	with(:cbn, 25.0..50.0)	
		    	searchbadges.push("25% < cbn < 50%")	
		    when "morethan50"
		    	with(:cbn).greater_than(50.0)
		    	searchbadges.push("cbn > 50%")
		    else		
	      end
  		  # sort by distance
  		  order_by_geodist(:location, geocoordiantes[0], geocoordiantes[1])						 

		end # search

			

				

		# loads all the objects from the db?
		#@store_items = @itemsearch.results 
		@store_items = @itemsearch.hits
		@filterpriceby = filterpriceby;
		 #generate next link for pagination
		orig = request.original_url 		# has the whole search se.rb form serialized, parameters and all
		uri = URI.parse(orig)
		uri_params = CGI.parse(uri.query)
		currentpagestr = uri_params['se[pg]'].first #not sure why it gets returned as an array.  The pagination control param.

		@searchbadges = searchbadges

		if currentpagestr.to_i == 1
			@counter = 1
		else	
			@counter = ((currentpagestr.to_i - 1)  * 100) + 1
		end
		nextpagenum = currentpagestr.to_i + 1;
		nextpagestr = nextpagenum.to_s
		@nextlink = orig.sub('se%5Bpg%5D=' + currentpagestr,'se%5Bpg%5D=' +nextpagestr)  # increment the pagination param by 1

		@isLastPage = @itemsearch.hits.last_page?		

		 if !itemquery || itemquery.empty?  || groupbystore
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
  :dd, #supersize
  :ee, #dogo
  
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
  :di,
  

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
  :filtercbn_range, :cbn_min, :cbn_max,

  #paginate
  :pg


			)		
	end	

	

end
