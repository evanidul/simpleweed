class SearchController < ApplicationController

	def search
		search = StoreItem.search do
		  #fulltext 'best'
		  with(:description).equal_to("best")

		  
		end

		@store_items = search.results
	end

end
