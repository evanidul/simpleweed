class ProfileFollowingPageComponent < SitePrism::Page
  
  # tab
  element :people_tab, '#following-people-tab'
  element :store_tab, '#following-store-tab'
  element :item_tab, '#following-items-tab'

  # the views
  elements :followed_users, '.followed-user'
  elements :followed_stores, '.followed-store'
  elements :followed_items, '.store-item'

  # follow/unfollow buttons
  elements :unfollow_user_buttons, '.unfollow-user-button'
  elements :follow_user_buttons, '.follow-user-button'  
  
  elements :unfollow_store_buttons, '.unfollow-store-button'
  elements :follow_store_buttons, '.follow-store-button'

end


