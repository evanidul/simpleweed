require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'

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

	scenario "check root" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		expect(page).to have_text("Hello"), "or else!"          
  	end

	scenario "sign in as admin test" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminemail)

    	stores_page = AdminStoresPage.new
    	stores_page.load
    	stores_page.has_newstore_button?    	
    	stores_page.newstore_button.click


  	end

	scenario "non-admins can't access admin store section" do

		email = "john@gmail.com"
		password = "password"
		user = User.new(:email => email, :password => password , :password_confirmation => password)
		user.skip_confirmation!
		user.save		
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set email
    	login_page.username_password_input.set password
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(email)

    	stores_page = AdminStoresPage.new
    	
    	# expect authorization exception and redirect
    	stores_page.load
    	
    	# should not be on the store admin page
    	stores_page.has_no_newstore_button?    	
  	end

	scenario "sign in as admin, create a new store, edit description" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminemail)

    	stores_page = AdminStoresPage.new
    	stores_page.load
    	stores_page.has_newstore_button?    	
    	stores_page.newstore_button.click

    	store_name = "My New Store"
    	stores_page.modal_store_name_input.set store_name
    	stores_page.modal_save_button.click

    	store_page = StorePage.new
    	store_page.has_name_header?
		expect(store_page.name_header.text).to have_text(store_name)    	
		store_page.has_description?
		expect(store_page.description.text).to have_text("Lorem ipsum dolor sit")    	

  	end
end
