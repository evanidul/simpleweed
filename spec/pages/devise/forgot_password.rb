class ForgotPasswordPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :user_login, "#user_login"
  element :send_reset_password_button, '#send_reset_password_button'


end