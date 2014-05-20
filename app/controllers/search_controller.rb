class SearchController < ApplicationController

	def search
		
		if params[:itemsearch]
			search = StoreItem.search do
			  fulltext params[:itemsearch]
			  # fulltext 'Sky'
			  # any_of do
			  # 	with(:name).equal_to(params[:itemsearch])
			  # 	with(:description).equal_to(params[:itemsearch])
			  	
			  # end

			end
		end

		@store_items = search.results
	end

end
