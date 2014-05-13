class SearchResultsStoresPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  # element :edituserlink, "#edit-user-link"

  # (2) is the first row because (1) is the th with "name", "address"
  element :firstSearchResult_row, "#store_results_table > div > div > table > tbody > tr:nth-child(2)"
  element :firstSearchResult_store_name, "#store_results_table > div > div > table > tbody > tr:nth-child(2) > td:nth-child(1) > span"


  #Store Preview
  element :store_name, "#store-name"

end