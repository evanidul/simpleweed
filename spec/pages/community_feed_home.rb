class CommunityFeedHomePage < SitePrism::Page
  # set_url "http://www.google.com"

  element :add_new_feed_button, "#add-new-feed-button"
  # add new feed modal
  element :new_feed_name_input, '#feed_name'
  element :save_feed_button, '#save_feed'

  elements :dynamic_feed_links ,'.dynamic-feed'
  
  
end