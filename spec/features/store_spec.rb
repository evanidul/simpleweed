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

	scenario "sign in as admin, create a new store, edit description, edit first time patient deals" do
				
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
		
		# check has default description
		expect(store_page.description.text).to have_text("Lorem ipsum dolor sit")    	
		store_page.has_description_edit_link?
		store_page.description_edit_link.click
		
		# change description
		new_description = "My New Description"
		store_page.store_description_input.set new_description
		store_page.has_save_store_description_button?
		store_page.save_store_description_button.click
		expect(store_page.description.text).to have_text(new_description)   

		# change first time patient deals
		store_page.has_first_time_patient_deals_text?		
		expect(store_page.first_time_patient_deals_text.text).to have_text("Lorem ipsum dolor sit")    	
		store_page.has_edit_first_time_patient_deals_link?
		store_page.edit_first_time_patient_deals_link.click
		new_ftpd = "No new deals today!"
		store_page.first_time_patient_deals_input.set new_ftpd
		store_page.save_first_time_patient_deals_button.click
		expect(store_page.first_time_patient_deals_text.text).to have_text(new_ftpd)    	

		# daily specials
		specials_default_value = "None."
		store_page.has_dailyspecials_sunday_text?
		expect(store_page.dailyspecials_sunday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_monday_text?
		expect(store_page.dailyspecials_monday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_tuesday_text?
		expect(store_page.dailyspecials_tuesday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_wednesday_text?
		expect(store_page.dailyspecials_wednesday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_thursday_text?
		expect(store_page.dailyspecials_thursday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_friday_text?
		expect(store_page.dailyspecials_friday_text.text).to have_text(specials_default_value)    	
		store_page.has_dailyspecials_saturday_text?
		expect(store_page.dailyspecials_saturday_text.text).to have_text(specials_default_value)    	

		store_page.edit_daily_specials_link.click
		store_page.dailyspecials_sunday_input.set "Sunday's Special"
		store_page.dailyspecials_monday_input.set "Monday's Special"
		store_page.dailyspecials_tuesday_input.set "Tuesday's Special"
		store_page.dailyspecials_wednesday_input.set "Wednesday's Special"
		store_page.dailyspecials_thursday_input.set "Thursday's Special"
		store_page.dailyspecials_friday_input.set "Friday's Special"
		store_page.dailyspecials_saturday_input.set "Saturday's Special"
		store_page.save_store_daily_specials_button.click
	
		expect(store_page.dailyspecials_sunday_text.text).to have_text("Sunday's Special")    			
		expect(store_page.dailyspecials_monday_text.text).to have_text("Monday's Special")    			
		expect(store_page.dailyspecials_tuesday_text.text).to have_text("Tuesday's Special")    			
		expect(store_page.dailyspecials_wednesday_text.text).to have_text("Wednesday's Special")    			
		expect(store_page.dailyspecials_thursday_text.text).to have_text("Thursday's Special")    	
		expect(store_page.dailyspecials_friday_text.text).to have_text("Friday's Special")    			
		expect(store_page.dailyspecials_saturday_text.text).to have_text("Saturday's Special")    	

		#contact check defaults and update
		expect(store_page.addressline1.text).to have_text("500 Montgomery St.")    			
		expect(store_page.city.text).to have_text("San Francisco")    						
		expect(store_page.state.text).to have_text("CA")    						
		expect(store_page.zip.text).to have_text("94705")    						
    	expect(store_page.phonenumber.text).to have_text("1 (415) GHOSTBUSTERS")    						

    	store_page.edit_contact_link.click
    	new_addressline1 = "7110 Rock Valley Court"
    	store_page.addressline1_input.set new_addressline1
    	new_addressline2 = "Apt. 506"
    	store_page.addressline2_input.set new_addressline2
    	new_city = "Denver"	
    	store_page.city_input.set new_city
    	new_state = "CO"
    	store_page.state_input.set new_state
    	new_zip = "92122"
    	store_page.zip_input.set new_zip
    	new_phonenumber = "1-415-123-1234"
    	store_page.phonenumber_input.set new_phonenumber
    	new_email = "evanidul@gmail.com"
    	store_page.email_input.set new_email
    	new_website = "www.evanidul.com"
    	store_page.website_input.set new_website
    	new_fb = "www.facebook.com/mypage"
    	store_page.facebook_input.set new_fb
    	new_twitter = "www.twitter.com/asd"
    	store_page.twitter_input.set new_twitter
    	new_instagram = "www.instagram.com/asdf"
    	store_page.instagram_input.set new_instagram

    	store_page.save_store_contact_button.click

		expect(store_page.addressline1.text).to have_text(new_addressline1)    			
		expect(store_page.addressline2.text).to have_text(new_addressline2)    			
		expect(store_page.city.text).to have_text(new_city)    						
		expect(store_page.state.text).to have_text(new_state)    						
		expect(store_page.zip.text).to have_text(new_zip)    						
    	expect(store_page.phonenumber.text).to have_text(new_phonenumber)    						
    	expect(store_page.email.text).to have_text(new_email)
    	expect(store_page.website.text).to have_text(new_website)
    	expect(store_page.facebook.text).to have_text(new_fb)
    	expect(store_page.twitter.text).to have_text(new_twitter)
    	expect(store_page.instagram.text).to have_text(new_instagram)
	
    	


  	end
end
