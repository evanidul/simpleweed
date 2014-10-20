class ProfileMyReviewsPageComponent < SitePrism::Page

  elements :store_reviews, ".store-review"
  elements :item_reviews, '.item-review'
  elements :posts, '.post-full-view'

  # nav
  element :store_review_tab, '#tabs-store-reviews'
  element :item_review_tab, '#tabs-reviews'
  element :com_posts_tab, '#tabs-comm-posts'
  

end


