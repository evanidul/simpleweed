class LoginPage < SitePrism::Page
  # set_url "http://www.google.com"
  element :username_input, "#user_email"
  element :username_password_input, "#user_password"
  element :sign_in_button, "#sign-in-button"
end