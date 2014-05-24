class HeaderPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :edituserlink, "#edit-user-link"
  element :loginlink, "#log-in-link"
  element :logoutlink, "#logout-link"

  #login modal
  element :username, "#user_login"
  element :password, "#user_password"
  element :logininbutton, "#log-in-button"
  element :forgot_password_link, "#forgot-password-link"

  #register modal
  element :register_link, "#register-link"
  element :register_username, "#user_username"
  element :register_email, "#user_email"
  element :register_password, "#user_password"
  element :register_password_confirmation, "#user_password_confirmation"
  element :create_account_button, "#create-account-button"

  #search bar
  element :search_input, "#search_itemsearch_location"
  element :search_button, "#submit-item-search"
  element :item_query_input, '#search_itemsearch'
  element :show_adv_search_button, '#show-search-filters'

  #search tabs
  element :search_opt_strain_and_attr_tab_link, '#search-opt-strain-and-attr-tab-link'
  element :search_opt_quantity_price_tab_link, '#search-opt-quantity-price-tab-link'
  element :search_opt_item_category_tab_link, '#search-opt-item-category-tab-link'
  element :search_opt_distance_tab_link, '#search-opt-distance-tab-link'
  element :search_opt_store_features_tab_link, '#search-opt-store-features-tab-link'
  element :search_opt_lab_tab_link, '#search-opt-lab-tab-link'
  element :search_opt_reviews_tab_link, '#search-opt-reviews-tab-link'

end