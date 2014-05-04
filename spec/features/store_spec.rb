require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'

feature "store page" , :js => true do
	before :each do
	  	@basicauthname = "ddadmin"
	  	@basicauthpassword = "idontreallysmoke" 
	  	page.visit("http://#{@basicauthname}:#{@basicauthpassword}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/")

	  	@adminemail = "evanidul@gmail.com"
	  	@adminpassword = "password"
		user = User.new(:email => @adminemail, :password => @adminpassword, :password_confirmation => @adminpassword)
		user.save
		user.add_role :admin # sets a global role

	end

	scenario "" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		expect(page).to have_content("Hello"), "or else!"          
  	end

	scenario "" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword

  	end



end
