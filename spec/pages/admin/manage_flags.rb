class AdminManageFlagsPage < SitePrism::Page
  set_url "/admin/flags/index"
  
  elements :delete_flag_buttons, '.delete-flag-button'
  
end