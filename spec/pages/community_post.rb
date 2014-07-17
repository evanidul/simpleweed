class CommunityPostPage < SitePrism::Page
  # set_url "http://www.google.com"

  element :post_title_link, ".post-title h2 a"
  
  element :new_comment_input, '.new-feed-post-comment-input'
  element :save_comment_button, '.save-new-feed-post-comment'

  elements :comments, '.feed-post-comment '

end