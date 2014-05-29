require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/registration'
require 'pages/devise/forgot_password'
require 'pages/devise/resend_confirmation'

feature "login page" , :js => true do
	
  before :each do
    if ENV['TARGETBROWSER'] == "chrome"
      Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
    page.driver.browser.manage.window.resize_to(1366,768)  #http://www.rapidtables.com/web/dev/screen-resolution-statistics.htm
  end
  end


  before :each do
	  	@basicauthname = "ddadmin"
	  	@basicauthpassword = "idontreallysmoke" 
	  	page.visit("http://#{@basicauthname}:#{@basicauthpassword}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/")

	  	@adminemail = "evanidul@gmail.com"
	  	@adminpassword = "password"
      @adminusername = "evanidul"
      user = User.new(:email => @adminemail, :password => @adminpassword, :password_confirmation => @adminpassword, :username => @adminusername)
  		user.skip_confirmation!
  		user.save
  		user.add_role :admin # sets a global role

	end

	scenario "login modal, good login" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)

  	end

  	scenario "login modal, bad login, good login at login page" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	# header.password.set @adminpassword
		header.logininbutton.click

		# on login page
		expect(page).to have_text("Invalid login or password"), "or else!"          		
		login_page = LoginPage.new
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminusername)

  	end

  	scenario "register modal, good registration" do
  		page.visit("/")
  		header = HeaderPageComponent.new
  		header.register_link.click

      username = "bob123"
  		email = "bob@gmail.com"
  		password = "password"
  		# register modal  		
  		header.register_username.set username
      header.register_email.set email
  		header.register_password.set password
  		header.register_password_confirmation.set password
  		header.create_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"          
  	end 	

  	scenario "register modal, enter duplicate email into modal, good registration on main reg page" do
  		page.visit("/")
  		header = HeaderPageComponent.new
  		header.register_link.click

      username = "evanidul"
  		email = "evanidul@gmail.com"
  		password = "password"
  		# register modal  		
  		header.register_username.set username
      header.register_email.set email
  		header.register_password.set password
  		header.register_password_confirmation.set password  		
  		header.create_account_button.click
  		
  		expect(page).to have_text("Email has already been taken"), "or else!" 
      expect(page).to have_text("Username has already been taken"), "or else!" 
		
  		registrationPage = RegistrationPageComponent.new
  		registrationPage.user_name.set "john123"
      registrationPage.user_email.set "john123@gmail.com"
  		registrationPage.user_password.set "password"
  		registrationPage.user_password_confirmation.set "password"
  		registrationPage.create_user_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"          

  	end

    scenario "admin tries to recover password" do

      page.visit("/")

      header = HeaderPageComponent.new
      header.has_loginlink?
      header.loginlink.click
        
      # login modal
      header.forgot_password_link.click

      # password recovery page
      forgot_password_page = ForgotPasswordPageComponent.new
      forgot_password_page.user_login.set @adminusername
      forgot_password_page.send_reset_password_button.click
      message = "You will receive an email with instructions on how to reset your password in a few minutes."
      expect(page).to have_text(message), "or else!"          
    end

  scenario "admin tries to recover password with email address instead of username" do

      page.visit("/")
      
      header = HeaderPageComponent.new
      header.has_loginlink?
      header.loginlink.click
        
      # login modal
      header.forgot_password_link.click

      # password recovery page
      forgot_password_page = ForgotPasswordPageComponent.new
      forgot_password_page.user_login.set @adminemail
      forgot_password_page.send_reset_password_button.click
      message = "You will receive an email with instructions on how to reset your password in a few minutes."
      expect(page).to have_text(message), "or else!"          
    end

    scenario "new user registers, then resends confirmation email using login name" do

      page.visit("/")
      header = HeaderPageComponent.new
      header.register_link.click

      username = "bob123"
      email = "bob@gmail.com"
      password = "password"
      # register modal      
      header.register_username.set username
      header.register_email.set email
      header.register_password.set password
      header.register_password_confirmation.set password
      header.create_account_button.click

      expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"   
      header.loginlink.click
      # login modal
      header.forgot_password_link.click
      # password recovery page
      forgot_password_page = ForgotPasswordPageComponent.new
      forgot_password_page.resend_confirmation_email_link.click

      # resend email confirmation page
      resend_email_confirmation_page = ResendConfirmationPageComponent.new
      resend_email_confirmation_page.user_login.set username
      resend_email_confirmation_page.resend_confirmation_email_button.click
      expect(page).to have_text("You will receive an email with instructions about how to confirm your account in a few minutes."), "or else!"   
    end

    scenario "new user registers, then resends confirmation email using email address" do

      page.visit("/")
      header = HeaderPageComponent.new
      header.register_link.click

      username = "bob123"
      email = "bob@gmail.com"
      password = "password"
      # register modal      
      header.register_username.set username
      header.register_email.set email
      header.register_password.set password
      header.register_password_confirmation.set password
      header.create_account_button.click

      expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"   
      header.loginlink.click
      # login modal
      header.forgot_password_link.click
      # password recovery page
      forgot_password_page = ForgotPasswordPageComponent.new
      forgot_password_page.resend_confirmation_email_link.click

      # resend email confirmation page
      resend_email_confirmation_page = ResendConfirmationPageComponent.new
      resend_email_confirmation_page.user_login.set email
      resend_email_confirmation_page.resend_confirmation_email_button.click
      expect(page).to have_text("You will receive an email with instructions about how to confirm your account in a few minutes."), "or else!"   
    end
end