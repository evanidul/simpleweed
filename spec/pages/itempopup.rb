class ItemPopupComponent < SitePrism::Page
  # set_url "http://www.google.com"
  #element :searchcontainer, "#home-page-search-container"
  
  
  # tabs
  element :tab_info, '#info-tab-link'
  element :tab_reviews, '#review-tab-link'
  element :tab_store, '#store-tab-link'


  # REVIEW TAB
  # write a review button
  element :write_review_button, '#review-item-slide-toggle-button'
  element :follow_item_button, '#follow-store-item-button'

  # review inputs
  element :onestar_button, '#rank_store_stars_1'
  element :twostar_button, '#rank_store_stars_2'
  element :threestar_button, '#rank_store_stars_3'
  element :fourstar_button, '#rank_store_stars_4'
  element :fivestar_button, '#rank_store_stars_5'

  element :review_text_input, '#store_item_review_review'
  element :save_review_button, '#save_store_item'

  # only shows when no reviews have been written
  element :be_the_first, ".alert-warning"

  # shows if you click on review button, after already writing a review  
  element :write_review_button_blocked_tooltip , '#write-review-blocked-tip'

  # alternate review button that shows up if you're a store owner or can't write a review b/c you already wrote one
  element :write_review_button_blocked, '#write-review-button-blocked-on-item-popup'

  # i cut and pasted the UI from stores, so the classes should be the same, even tho semantically incorrect
  elements :review_content, '.review-content'
  elements :star_ranking, "#item-popup-review-tab-review-container .store-star-rank"
  elements :review_vote_sum, '.review-votes'
  elements :upvotebutton, '.upvotebutton'
  elements :downvotebutton, '.downvotebutton'
  elements :new_comment_inputs, '.new-item-review-comment-input'
  elements :save_new_comment_button, '.save-new-store-review-comment'
  elements :item_review_comments, '.store-review-comment'

  # can't comment when logged out, log in links rendered inline
  elements :log_in_to_comment_links, '.login-to-comment-on-item-review'

  # bootstrap alert on modal on reviews tab
  elements :alerts_on_reviews_tab, ".flash_notice"

  element :cancel_button, '#cancel-button'

  elements :user_links, '.user-link'

  # STORE TAB
  element :store_tab_follow_button, '#follow-store-button'
  element :store_tab_unfollow_button, '#unfollow-store-button'
  element :store_tab_view_store_button, '#view-store-button'
end