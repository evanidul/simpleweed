class ProfileFeedPageComponent < SitePrism::Page
  
  
  # various types of feed items
  
  # STORE feed items
  elements :store_announcement_updates, ".feed-item-store-announcement-update"
  elements :store_description_updates, ".feed-item-store-description-update"

end


