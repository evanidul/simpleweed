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
  element :search_input, "#se_isl"
  element :search_button, "#submit-item-search"
  element :item_query_input, '#se_itemsearch'
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
  element :indica, '#se_o'
  element :sativa, '#se_p'
  element :hybrid, '#se_q'
  # cultivation
  element :indoor, '#se_u'
  element :outdoor, '#se_v'
  element :hydroponic, '#se_w'
  element :greenhouse, '#se_x'
  element :organic, '#se_y'
  # misc
  element :privatereserve, '#se_z'
  element :topshelf, '#se_aa'
  element :glutenfree, '#se_bb'
  element :sugarfree, '#se_cc'

  # PRICE #################
  element :search_filterpriceby_, '#se_fpb_'  #none
  element :search_filterpriceby_halfgram, '#se_fpb_halfgram'
  element :search_filterpriceby_gram, '#se_fpb_gram'
  element :search_filterpriceby_eighth, '#se_fpb_eighth'
  element :search_filterpriceby_quarteroz, '#se_fpb_quarteroz'
  element :search_filterpriceby_halfoz, '#se_fpb_halfoz'
  element :search_filterpriceby_oz, '#se_fpb_oz'

  element :search_pricerangeselect_custom, '#se_prs_custom'
  element :search_minprice, '#se_mp'
  element :search_maxprice, '#se_xp'

  element :search_pricerangeselect_, '#se_prs_' #none
  element :search_pricerangeselect_lessthan25, '#se_prs_lessthan25'
  element :search_pricerangeselect_between25and50, '#se_prs_between25and50'
  element :search_pricerangeselect_between50and100, '#se_prs_between50and100'
  element :search_pricerangeselect_between100and200, '#se_prs_between100and200'
  element :search_pricerangeselect_morethan200, '#se_prs_morethan200'

  # ITEM CATEGORY ###########
  # flower
  element :bud, '#se_i1'
  element :shake, '#se_i2'
  element :trim, '#se_i3'
  # concentrate
  element :wax, '#se_i4'
  element :hash, '#se_i5'
  element :budder_earwax_honeycomb,'#se_i6'
  element :bubblehash_fullmelt_icewax, '#se_i7'
  element :ISOhash, '#se_i8'
  element :kief_drysieve, '#se_i9'
  element :shatter_amberglass, '#se_i10'
  element :scissor_fingerhash, '#se_i11'
  element :oil_cartridge, '#se_i12'
  # edible
  element :baked, '#se_i13'
  element :candy_chocolate, '#se_i14'
  element :cooking, '#se_i15'
  element :drink, '#se_i16'
  element :frozen, '#se_i17'
  element :other_edibles, '#se_i18'
  # pre-rolls
  element :blunt, '#se_i19'
  element :joint, '#se_i20'
  # other
  element :clones, '#se_i21'
  element :seeds, '#se_i22'
  element :oral, '#se_i23'
  element :topical, '#se_i24'
  # accessory
  element :bong_pipe, '#se_i25'
  element :bong_pipe_accessories, '#se_i26'
  element :book_magazine, '#se_i27'
  element :butane_lighter, '#se_i28'
  element :cleaning, '#se_i29'
  element :clothes, '#se_i30'
  element :grinder, '#se_i31'
  element :other_accessories, '#se_i32'
  element :paper_wrap, '#se_i33'
  element :storage, '#se_i34'
  element :vape, '#se_i35'
  element :vape_accessories,'#se_i36'

  # STORE FEATURES ###########
  element :deliveryservice , '#se_a'
  element :acceptsatmcredit ,'#se_b'
  element :atmaccess , '#se_c'
  element :dispensingmachines, '#se_d'

  element :firsttimepatientdeals, '#se_e'
  element :handicapaccess, '#se_f'
  element :loungearea, '#se_g'
  element :pet_friendly, '#se_h'

  element :security_guard, '#se_i'
  element :eighteenplus ,'#se_j'
  element :twentyoneplus ,'#se_k'
  element :hasphotos, '#se_l'

  element :labtested ,'#se_m'
  element :onsitetesting, '#se_n'

  # LAB #####################
  element :thc_none, '#se_filterthc_range_'
  element :thc_custom, '#se_filterthc_range_custom'
  element :thc_min, '#se_thc_min'
  element :thc_max, '#se_thc_max'
  element :thc_lessthanfive, '#se_filterthc_range_lessthan5'
  element :thc_fivetoten, '#se_filterthc_range_between5and10'
  element :thc_tentotwentyfive, '#se_filterthc_range_between10-25'
  element :thc_twentyfivetofifty, '#se_filterthc_range_between25and50'
  element :thc_morethanfifty, '#se_filterthc_range_morethan50'

  element :cbd_none, '#se_filtercbd_range_'
  element :cbd_custom, '#se_filtercbd_range_custom'
  element :cbd_min, '#se_cbd_min'
  element :cbd_max, '#se_cbd_max'
  element :cbd_lessthanfive, '#se_filtercbd_range_lessthan5'
  element :cbd_fivetoten, '#se_filtercbd_range_between5and10'
  element :cbd_tentotwentyfive, '#se_filtercbd_range_between10-25'
  element :cbd_twentyfivetofifty, '#se_filtercbd_range_between25and50'
  element :cbd_morethanfifty, '#se_filtercbd_range_morethan50'

  element :cbn_none, '#se_filtercbn_range_'
  element :cbn_custom, '#se_filtercbn_range_custom'
  element :cbn_min, '#se_cbn_min'
  element :cbn_max, '#se_cbn_max'
  element :cbn_lessthanfive, '#se_filtercbn_range_lessthan5'
  element :cbn_fivetoten, '#se_filtercbn_range_between5and10'
  element :cbn_tentotwentyfive, '#se_filtercbn_range_between10-25'
  element :cbn_twentyfivetofifty, '#se_filtercbn_range_between25and50'
  element :cbn_morethanfifty, '#se_filtercbn_range_morethan50'


end