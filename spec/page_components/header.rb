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

  # STRAIN ################

  # strain
  element :indica, '#search_indica'
  element :sativa, '#search_sativa'
  element :hybrid, '#search_hybrid'
  # cultivation
  element :indoor, '#search_indoor'
  element :outdoor, '#search_outdoor'
  element :hydroponic, '#search_hydroponic'
  element :greenhouse, '#search_greenhouse'
  element :organic, '#search_organic'
  # misc
  element :privatereserve, '#search_privatereserve'
  element :topshelf, '#search_topshelf'
  element :glutenfree, '#search_glutenfree'
  element :sugarfree, '#search_sugarfree'

  # PRICE #################
  element :search_filterpriceby_, '#search_filterpriceby_'  #none
  element :search_filterpriceby_halfgram, '#search_filterpriceby_halfgram'
  element :search_filterpriceby_gram, '#search_filterpriceby_gram'
  element :search_filterpriceby_eighth, '#search_filterpriceby_eighth'
  element :search_filterpriceby_quarteroz, '#search_filterpriceby_quarteroz'
  element :search_filterpriceby_halfoz, '#search_filterpriceby_halfoz'
  element :search_filterpriceby_oz, '#search_filterpriceby_oz'

  element :search_pricerangeselect_custom, '#search_pricerangeselect_custom'
  element :search_minprice, '#search_minprice'
  element :search_maxprice, '#search_maxprice'

  element :search_pricerangeselect_, '#search_pricerangeselect_' #none
  element :search_pricerangeselect_lessthan25, '#search_pricerangeselect_lessthan25'
  element :search_pricerangeselect_between25and50, '#search_pricerangeselect_between25and50'
  element :search_pricerangeselect_between50and100, '#search_pricerangeselect_between50and100'
  element :search_pricerangeselect_between100and200, '#search_pricerangeselect_between100and200'
  element :search_pricerangeselect_morethan200, '#search_pricerangeselect_morethan200'

  # ITEM CATEGORY ###########
  # flower
  element :bud, '#search_bud'
  element :shake, '#search_shake'
  element :trim, '#search_trim'
  # concentrate
  element :wax, '#search_wax'
  element :hash, '#search_hash'
  element :budder_earwax_honeycomb,'#search_budder_earwax_honeycomb'
  element :bubblehash_fullmelt_icewax, '#search_bubblehash_fullmelt_icewax'
  element :ISOhash, '#search_ISOhash'
  element :kief_drysieve, '#search_kief_drysieve'
  element :shatter_amberglass, '#search_shatter_amberglass'
  element :scissor_fingerhash, '#search_scissor_fingerhash'
  element :oil_cartridge, '#search_oil_cartridge'
  # edible
  element :baked, '#search_baked'
  element :candy_chocolate, '#search_candy_chocolate'
  element :cooking, '#search_cooking'
  element :drink, '#search_drink'
  element :frozen, '#search_frozen'
  element :other_edibles, '#search_other_edibles'
  # pre-rolls
  element :blunt, '#search_blunt'
  element :joint, '#search_joint'
  # other
  element :clones, '#search_clones'
  element :seeds, '#search_seeds'
  element :oral, '#search_oral'
  element :topical,'#search_topical'
  # accessory
  element :bong_pipe, '#search_bong_pipe'
  element :bong_pipe_accessories, '#search_bong_pipe_accessories'
  element :book_magazine, '#search_book_magazine'
  element :butane_lighter, '#search_butane_lighter'
  element :cleaning, '#search_cleaning'
  element :clothes, '#search_clothes'
  element :grinder, '#search_grinder'
  element :other_accessories, '#search_other_accessories'
  element :paper_wrap, '#search_paper_wrap'
  element :storage, '#search_storage'
  element :vape, '#search_vape'
  element :vape_accessories,'#search_vape_accessories'

end