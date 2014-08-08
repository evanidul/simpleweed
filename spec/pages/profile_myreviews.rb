class ProfileMyReviewsPageComponent < SitePrism::Page

  elements :store_reviews, ".store-review"
  elements :item_reviews, '.item-review'

  # nav
  element :store_review_tab, '#store-reviews'
  element :item_review_tab, '#tabs-reviews'

  

end


