# detail view of a post, it's post content, and the comments on the page
class CommunityPostPage < SitePrism::Page
  # set_url "http://www.google.com"

  element :post_title_link, ".post-title h2 a"
  elements :post_post_content, ".post-post"

  element :new_comment_input, '.new-feed-post-comment-input'
  element :save_comment_button, '.save-new-feed-post-comment'

  elements :comments, '.feed-post-comment '

  element :delete_post_button, '#delete-post-button'
  # delete post modal
  element :delete_post_verify_button, '#delete_post_submit'

end