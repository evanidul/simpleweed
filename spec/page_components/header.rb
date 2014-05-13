class HeaderPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :edituserlink, "#edit-user-link"
  element :loginlink, "#log-in-link"

  #login modal
  element :username, "#user_email"
  element :password, "#user_password"
  element :logininbutton, "#log-in-button"

  #register modal
  element :register_link, "#register-link"
  element :register_username, "#user_email"
  element :register_password, "#user_password"
  element :register_password_confirmation, "#user_password_confirmation"
  element :create_account_button, "#create-account-button"

  #search bar
  element :search_input, "#search"
  element :search_button, "#submit-search"


end