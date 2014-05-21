class SearchController < ApplicationController

	def search
		
		if params[:itemsearch]
			@itemsearch = StoreItem.search do
			  fulltext params[:itemsearch] do
			  	highlight :name
			  	highlight :description
			  	highlight :store_name

			  	
			  end
			  # within 5 kilometers of 34, 118 (LA, CA)
	  		  with(:location).in_radius(34, -118, 100)
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
	end

end
