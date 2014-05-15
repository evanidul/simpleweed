class RegistrationPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :user_name, "#user_username"
  element :user_email, "#user_email"
  element :user_password, "#user_password"
  element :user_password_confirmation, "#user_password_confirmation"
  element :create_user_account_button, "#create-user-account-button"

end