class AdminManageFlagsPage < SitePrism::Page
  set_url "/admin/flags/index"
  
  elements :delete_flag_buttons, '.delete-flag-button'
  elements :post_links, '.post-link'

end