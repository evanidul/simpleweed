require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/registration'
require 'pages/homepage'

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
		homepage = HomePageComponent.new
    homepage.has_searchcontainer?          

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
		homepage = HomePageComponent.new
    homepage.has_searchcontainer?   

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

  		username = "bob@gmail.com"
  		password = "password"
  		# register modal  		
  		header.register_username.set username
  		header.register_password.set password
  		header.register_password_confirmation.set password
  		header.create_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"          
  	end 	

  	scenario "register modal, enter bad into modal, good registration on main reg page" do
  		page.visit("/")
  		header = HeaderPageComponent.new
  		header.register_link.click

  		username = "bob@gmail.com"
  		password = "password"
  		# register modal  		
  		header.register_username.set username
  		# header.register_password.set password
  		header.register_password_confirmation.set password  		
  		header.create_account_button.click
  		
  		expect(page).to have_text("Password can't be blank"), "or else!" 
		
  		registrationPage = RegistrationPageComponent.new
  		registrationPage.user_name.set username
  		registrationPage.user_password.set password
  		registrationPage.user_password_confirmation.set password
  		registrationPage.create_user_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"          

  	end

end