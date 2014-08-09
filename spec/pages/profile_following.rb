class ProfileFollowingPageComponent < SitePrism::Page
  
  # tab
  element :people_tab, '#following-people-tab'
  element :store_tab, '#following-store-tab'
  element :item_tab, '#following-items-tab'

  elements :followed_users, '.followed-user'
  elements :followed_stores, '.followed-store'
  elements :followed_items, '.store-item'

  elements :unfollow_user_buttons, '.unfollow-user-button'
  elements :follow_user_buttons, '.follow-user-button'  
  

end


