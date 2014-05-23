class SearchController < ApplicationController

	def search


		itemquery = params[:itemsearch]
		searchLocation = params[:itemsearch_location]
		if searchLocation.nil? || searchLocation.empty?
			searchLocation = "la,ca"
		end

		if params[:groupbystore] == 'true'
			groupbystore = true
		else
			groupbystore = false
		end	

		if !itemquery || itemquery.empty?
			redirect_to stores_path(:search => searchLocation )
			return
		end

		if params[:itemsearch]
			@itemsearch = StoreItem.search do				
				if groupbystore
					group :store_id_str do
						limit 3
					end
				end # if
				paginate :page => 1, :per_page => 100
			  	fulltext params[:itemsearch] do
					  	highlight :name
					  	highlight :description
					  	highlight :store_name
				end # fulltext
			  
			  
			  geocoordiantes = Geocoder.coordinates(searchLocation);
			  # within 5 kilometers of 34, 118 (LA, CA)
	  		  with(:location).in_radius(geocoordiantes[0], geocoordiantes[1], 100)

	  		  # sort by distance
	  		  order_by_geodist(:location, geocoordiantes[0], geocoordiantes[1])

			  # fulltext 'Sky'
			  # any_of do
			  # 	with(:name).equal_to(params[:itemsearch])
			  # 	with(:description).equal_to(params[:itemsearch])
			  	
			  # end

			end # search

			

		end # if

		# loads all the objects from the db?
		#@store_items = @itemsearch.results 
		 @store_items = @itemsearch.hits


		 if groupbystore
		 	render 'search_group_by_store'
		 end

	end # end search endpoint

end
