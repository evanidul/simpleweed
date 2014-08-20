class StoreArchivedItemsPage < SitePrism::Page
	#set_url "/admin/stores"

	element :back_to_menu_link, "#menu-items-link"

	elements :searchresults, "#table_div > div > div > table > tbody > tr > td:nth-child(2)"
	
	def row_links
	    searchresults.map {|row| row['data-remote']}
	end

	# restore modal
	element :unarchive_button, '#unarchive_item_submit'

end