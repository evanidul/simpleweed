class HeaderPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :edituserlink, "#edit-user-link"
  element :loginlink, "#log-in-link"

  #login modal
  element :username, "#user_email"
  element :password, "#user_password"
  element :logininbutton, "#log-in-button"

end