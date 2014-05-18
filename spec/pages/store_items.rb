class StoreItemsPage < SitePrism::Page
	#set_url "/admin/stores"

	element :store_name, "#store_name"
	element :add_store_item_button, "#new_store_item"

	element :firstSearchResult_row, "#table_div > div > div > table > tbody > tr:nth-child(2)"
	element :firstSearchResult_item_name, "#table_div > div > div > table > tbody > tr:nth-child(2) > td:nth-child(1)"


	# add item panel
	element :store_item_name, '#store_item_name'
	element :store_item_description, '#store_item_description'
	element :thc, '#thc-percent'
	element :cbd,'#cbd-percent'
	element :cbn, '#cbn-percent'

	element :store_item_costhalfgram, '#store_item_costhalfgram'
	element :store_item_costonegram, '#store_item_costonegram'
	element :store_item_costeighthoz, '#store_item_costeighthoz'
	element :store_item_costquarteroz, '#store_item_costquarteroz'
	element :store_item_costhalfoz, '#store_item_costhalfoz'
	element :store_item_costoneoz, '#store_item_costoneoz'

	element :store_item_dogo, "#store_item_dogo"

	element :save_store_item_button, "#save_store_item"
	element :close_button, "#close-button"

end