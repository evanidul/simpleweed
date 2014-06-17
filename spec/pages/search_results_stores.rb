class SearchResultsStoresPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  # element :edituserlink, "#edit-user-link"

  # (2) is the first row because (1) is the th with "name", "address"
  #element :firstSearchResult_row, "#store_results_table > div > div > table > tbody > tr:nth-child(2)"
  #element :firstSearchResult_store_name, "#store_results_table > div > div > table > tbody > tr:nth-child(2) > td:nth-child(1) > span"

  #element :firstSearchResult_store_name, "#main-container > .item-search-result-container:first > div > h4 > a"

  #elements :search_results_store_names, "#main-container > .item-search-result-container > div > h4 > a"
  elements :search_results_store_names, "#search-results > div > div > table > tbody > tr > td > h4 > a"

  elements :search_results_item_names, '.item-search-item-name > a'

  element :flash_warning, ".alert-warning"

  #Store Preview
  #element :store_name, "#store-name"

end