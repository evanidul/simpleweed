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

  # review inputs
  element :review_text_input, '#store_item_review_review'
  element :save_review_button, '#save_store_item'

  element :be_the_first, ".alert-warning"

  # i cut and pasted the UI from stores, so the classes should be the same, even tho semantically incorrect
  elements :review_content, '.review-content'
  elements :star_ranking, '.store-star-rank'
  elements :review_vote_sum, '.review-votes'
  elements :upvotebutton, '.upvotebutton'
  elements :downvotebutton, '.downvotebutton'
  elements :new_comment_inputs, '.new-item-review-comment-input'
  elements :save_new_comment_button, '.save-new-store-review-comment'
  elements :store_review_comments, '.store-review-comment'

end