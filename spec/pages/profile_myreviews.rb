class ProfileMyReviewsPageComponent < SitePrism::Page

  elements :store_reviews, ".store-review"
  elements :item_reviews, '.item-review'
  
  elements :posts, '.post-full-view'
  elements :edit_post_links, '.edit-post-links'
  element :post_content_input, '#feed_post_post'
  element :save_post_button, '#save_feed_post'

  # nav
  element :store_review_tab, '#tabs-store-reviews'
  element :item_review_tab, '#tabs-reviews'
  element :com_posts_tab, '#tabs-comm-posts'
  

end


