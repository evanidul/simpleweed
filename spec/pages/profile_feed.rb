class ProfileFeedPageComponent < SitePrism::Page
  
  
  # various types of feed items
  
  # STORE feed items
  elements :store_announcement_updates, ".feed-item-store-announcement-update"
  elements :store_description_updates, ".feed-item-store-description-update"
  elements :store_dailyspecials_updates, ".feed-item-store-dailyspecials-update"
  elements :store_hours_updates, ".feed-item-store-hours-update"
  elements :store_ftp_updates, ".feed-item-store-ftp-update"
  elements :store_contact_updates, ".feed-item-store-contact-update"

  # USER feed items
  elements :user_following_user_feed_items, '.feed-item-user-following-user'

end


