class CommunityFeedPage < SitePrism::Page
  # set_url "http://www.google.com"

  element :feed_name_span, '#feed-name'
  element :add_new_post_button, "#add-new-post-button"

  # new post modal
  element :feed_post_title_input, '#feed_post_title'  
  element :text_tab, '#feed-post-text-input'
  element :link_tab, '#feed-post-link-input'
  element :feed_post_content_input, '#feed_post_post'
  element :feed_link_input, '#feed_post_link'
  element :save_post_button, '#save_feed_post'
  
  # posts
  elements :post_titles, '.post-title a'
  elements :post_username_links, '.user-link'

end