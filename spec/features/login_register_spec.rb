require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'



feature "store page" , :js => true do
	before :each do
	  	@basicauthname = "ddadmin"
	  	@basicauthpassword = "idontreallysmoke" 
	  	page.visit("http://#{@basicauthname}:#{@basicauthpassword}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/")

	  	@adminemail = "evanidul@gmail.com"
	  	@adminpassword = "password"
		user = User.new(:email => @adminemail, :password => @adminpassword, :password_confirmation => @adminpassword)
		user.skip_confirmation!
		user.save
		user.add_role :admin # sets a global role

	end

	scenario "login modal, good login" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		expect(page).to have_text("Hello"), "or else!"          

		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminemail)

  	end

  	scenario "register modal, good registration" do
  		page.visit("/")
  		header = HeaderPageComponent.new
  		header.register_link.click

  		username = "bob@gmail.com"
  		password = "password"
  		# register modal
  		binding.pry
  		header.register_username.set username
  		header.register_password.set password
  		header.register_password_confirmation.set password
  		header.create_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"          

  		


  	end 	


end