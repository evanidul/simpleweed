# a feed page, diy, faq, etc.

class CommunityFeedPage < SitePrism::Page
  # set_url "http://www.google.com"

  element :feed_name_span, '#feed-name'
  element :add_new_post_button, "#add-new-post-button"

  # new post modal
  element :feed_post_title_input, '#feed_post_title'  
  element :text_tab, '#text-tab'
  element :link_tab, '#link-tab'
  element :feed_post_content_input, '#feed_post_post'
  element :feed_link_input, '#feed_post_link'
  element :save_post_button, '#save_feed_post'
  
  # posts
  elements :post_titles, '.post-title a'
  elements :post_username_links, '.user-link'
  elements :post_comments_link, '.post_comment_link'
  elements :post_upvote_buttons, '.upvotebutton'
  elements :post_flash_notices, '.flash_notice'


end