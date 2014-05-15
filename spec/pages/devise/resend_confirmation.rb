class ResendConfirmationPageComponent < SitePrism::Page
  # set_url "http://www.google.com"
  element :user_login, "#user_login"
  element :resend_confirmation_email_button, '#resend-confirmation-email-button'

end