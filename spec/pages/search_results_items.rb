class SearchResultsItemPageComponent < SitePrism::Page
  # set_url "http://www.google.com"

  elements :searchresults_item_names, ".item-search-item-name-main-page"
  elements :searchresults_store_names, '.search-results-store-links'

  # badges
  elements :badge_supersize, ".search-item-badge-supersize"  
  elements :badge_bogo, ".search-item-badge-bogo"  

  # cultivation is a badge that may be several different values, but we just check this one b/c i'm lazy.
  elements :badge_indoor, ".search-item-badge-indoor"

  elements :badge_og, ".search-item-badge-og"
  elements :badge_kush, ".search-item-badge-kush"
  elements :badge_haze, ".search-item-badge-haze"

  elements :badge_organic, ".search-item-badge-organic"
  elements :badge_sugarfree, ".search-item-badge-sugarfree"
  elements :badge_glutenfree, ".search-item-badge-glutenfree"
  elements :badge_topshelf, ".search-item-badge-topshelf"
  elements :badge_privatereserve, ".search-item-badge-privatereserve"
  
end