require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'

feature "store page" , :js => true do

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

	scenario "check root" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		homepage = HomePageComponent.new
		homepage.has_searchcontainer?
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
    	expect(header.edituserlink.text).to have_text(@adminusername)

    	stores_page = AdminStoresPage.new
    	stores_page.load
    	stores_page.has_newstore_button?    	
    	stores_page.newstore_button.click


  	end

	scenario "non-admins can't access admin store section" do

		email = "john@gmail.com"
		username = "john123"
		password = "password"
		user = User.new(:email => email, :password => password , :password_confirmation => password, :username =>username)
		user.skip_confirmation!
		user.save		
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set username
    	login_page.username_password_input.set password
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?		
    	expect(header.edituserlink.text).to have_text(username)

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

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminusername)

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
		expect(store_page.description.text).to have_text("None.")    	
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
		expect(store_page.first_time_patient_deals_text.text).to have_text("None.")    	
		   # None means the db has null or "".  Therefore, there are no deals and it should be unchecked		
		store_page.firsttimepatientdeals.should_not be_checked
		store_page.has_edit_first_time_patient_deals_link?
		store_page.edit_first_time_patient_deals_link.click
		new_ftpd = "No new deals today!"
		store_page.first_time_patient_deals_input.set new_ftpd
		store_page.save_first_time_patient_deals_button.click
		expect(store_page.first_time_patient_deals_text.text).to have_text(new_ftpd)    	
		store_page.firsttimepatientdeals.should be_checked

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
	
		#features
		#ftpd is true because we have a default text for it
		expect(store_page.firsttimepatientdeals).to be_checked
		
		store_page.acceptscreditcards.should_not be_checked
		store_page.atmaccess.should_not be_checked
		store_page.automaticdispensingmachines.should_not be_checked
		store_page.deliveryservice.should_not be_checked
		store_page.handicapaccess.should_not be_checked
		store_page.loungearea.should_not be_checked
		store_page.petfriendly.should_not be_checked
		store_page.securityguard.should_not be_checked
		store_page.labtested.should_not be_checked
		store_page.eighteenplus.should_not be_checked
		store_page.twentyoneplus.should_not be_checked
		store_page.hasphotos.should_not be_checked
		store_page.onsitetesting.should_not be_checked

		store_page.edit_features_link.click
		
		# update features
		store_page.acceptscreditcards_input.set true
		store_page.atmaccess_input.set true		
		store_page.automaticdispensingmachines_input.set true		
		store_page.deliveryservice_input.set true		
		store_page.handicapaccess_input.set true		
		store_page.loungearea_input.set true		
		store_page.petfriendly_input.set true		
		store_page.securityguard_input.set true		
		store_page.labtested_input.set true		
		store_page.eighteenplus_input.set true		
		store_page.twentyoneplus_input.set true		
		store_page.hasphotos_input.set true		
		store_page.onsitetesting_input.set true		

		store_page.save_store_features_button.click

		store_page.firsttimepatientdeals.should be_checked  #we didn't change this, so still checked

		store_page.acceptscreditcards.should be_checked
		store_page.atmaccess.should be_checked
		store_page.automaticdispensingmachines.should be_checked
		store_page.deliveryservice.should be_checked
		store_page.handicapaccess.should be_checked
		store_page.loungearea.should be_checked
		store_page.petfriendly.should be_checked
		store_page.securityguard.should be_checked
		store_page.labtested.should be_checked
		store_page.eighteenplus.should be_checked
		store_page.twentyoneplus.should be_checked
		store_page.hasphotos.should be_checked
		store_page.onsitetesting.should be_checked

		# announcement
		expect(store_page.announcement.text).to have_text("None.")
		store_page.edit_announcement_link.click
		new_announcement = "My New announcement"
		store_page.announcement_input.set new_announcement
		store_page.save_announcement_button.click
		expect(store_page.announcement.text).to have_text(new_announcement)

		# delivery area
		expect(store_page.deliveryarea.text).to have_text("None.")
		store_page.edit_deliveryarea_link.click
		new_deliveryarea = "Montgomery"
		store_page.deliveryarea_input.set new_deliveryarea
		store_page.save_store_deliveryarea_button.click
		expect(store_page.deliveryarea.text).to have_text(new_deliveryarea)
  	end

  		scenario "sign in as admin, create a new store, edit store hours" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminusername)

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

		store_page.edit_hours_link.click
		store_page.save_store_hours_button.click # first save opens the store, 12AM - 12AM, ie always open

		default_hours = "12:00 AM - 12:00 AM"

		expect(store_page.sunday_hours.text).to have_text(default_hours) 
		expect(store_page.monday_hours.text).to have_text(default_hours) 
		expect(store_page.tuesday_hours.text).to have_text(default_hours)
		expect(store_page.wednesday_hours.text).to have_text(default_hours)
		expect(store_page.thursday_hours.text).to have_text(default_hours)
		expect(store_page.friday_hours.text).to have_text(default_hours)
		expect(store_page.saturday_hours.text).to have_text(default_hours) 				

		#update them hours
		store_page.edit_hours_link.click

		sunday_open_h = "01"
		sunday_open_m = "15"
		sunday_close_h = "13"
		sunday_close_m = "30"

		monday_open_h = "02"
		monday_open_m = "30"
		monday_close_h = "14"
		monday_close_m = "45"

		tuesday_open_h = "03"
		tuesday_open_m = "45"
		tuesday_close_h = "15"
		tuesday_close_m = "00"

		wednesday_open_h = "10"
		wednesday_open_m = "00"
		wednesday_close_h = "20"
		wednesday_close_m = "15"

		thursday_open_h = "11"
		thursday_open_m = "15"
		thursday_close_h = "21"
		thursday_close_m = "15"

		friday_open_h = "13"
		friday_open_m = "30"
		friday_close_h = "23"
		friday_close_m = "30"

		saturday_open_h = "14"
		saturday_open_m = "45"
		saturday_close_h = "23"
		saturday_close_m = "45"

		#store_page.date_storehourssundayopenhour.find("option[value='12']").select_option
		store_page.date_storehourssundayopenhour.find("option[value='" + sunday_open_h +"']").select_option
		store_page.date_storehourssundayopenminute.find("option[value='" + sunday_open_m +"']").select_option
		store_page.date_storehourssundayclosehour.find("option[value='" + sunday_close_h +"']").select_option
		store_page.date_storehourssundaycloseminute.find("option[value='" + sunday_close_m +"']").select_option
		
		store_page.date_storehoursmondayopenhour.find("option[value='" + monday_open_h +"']").select_option
		store_page.date_storehoursmondayopenminute.find("option[value='" + monday_open_m +"']").select_option
		store_page.date_storehoursmondayclosehour.find("option[value='" + monday_close_h +"']").select_option
		store_page.date_storehoursmondaycloseminute.find("option[value='" + monday_close_m +"']").select_option

		store_page.date_storehourstuesdayopenhour.find("option[value='" + tuesday_open_h +"']").select_option
		store_page.date_storehourstuesdayopenminute.find("option[value='" + tuesday_open_m +"']").select_option
		store_page.date_storehourstuesdayclosehour.find("option[value='" + tuesday_close_h +"']").select_option
		store_page.date_storehourstuesdaycloseminute.find("option[value='" + tuesday_close_m +"']").select_option

		store_page.date_storehourswednesdayopenhour.find("option[value='" + wednesday_open_h +"']").select_option
		store_page.date_storehourswednesdayopenminute.find("option[value='" + wednesday_open_m +"']").select_option
		store_page.date_storehourswednesdayclosehour.find("option[value='" + wednesday_close_h +"']").select_option
		store_page.date_storehourswednesdaycloseminute.find("option[value='" + wednesday_close_m +"']").select_option

		store_page.date_storehoursthursdayopenhour.find("option[value='" + thursday_open_h +"']").select_option
		store_page.date_storehoursthursdayopenminute.find("option[value='" + thursday_open_m +"']").select_option
		store_page.date_storehoursthursdayclosehour.find("option[value='" + thursday_close_h +"']").select_option
		store_page.date_storehoursthursdaycloseminute.find("option[value='" + thursday_close_m +"']").select_option

		store_page.date_storehoursfridayopenhour.find("option[value='" + friday_open_h +"']").select_option
		store_page.date_storehoursfridayopenminute.find("option[value='" + friday_open_m +"']").select_option
		store_page.date_storehoursfridayclosehour.find("option[value='" + friday_close_h +"']").select_option
		store_page.date_storehoursfridaycloseminute.find("option[value='" + friday_close_m +"']").select_option

		store_page.date_storehourssaturdayopenhour.find("option[value='" + saturday_open_h +"']").select_option
		store_page.date_storehourssaturdayopenminute.find("option[value='" + saturday_open_m +"']").select_option
		store_page.date_storehourssaturdayclosehour.find("option[value='" + saturday_close_h +"']").select_option
		store_page.date_storehourssaturdaycloseminute.find("option[value='" + saturday_close_m +"']").select_option

		store_page.save_store_hours_button.click 

		# verify 
		expect(store_page.sunday_hours.text).to have_text("1:15 AM") 
		expect(store_page.sunday_hours.text).to have_text("1:30 PM") 

		expect(store_page.monday_hours.text).to have_text("2:30 AM") 
		expect(store_page.monday_hours.text).to have_text("2:45 PM") 
		
		expect(store_page.tuesday_hours.text).to have_text("3:45 AM") 
		expect(store_page.tuesday_hours.text).to have_text("3:00 PM") 
		
		expect(store_page.wednesday_hours.text).to have_text("10:00 AM") 
		expect(store_page.wednesday_hours.text).to have_text("8:15 PM") 

		expect(store_page.thursday_hours.text).to have_text("11:15 AM") 
		expect(store_page.thursday_hours.text).to have_text("9:15 PM") 
		
		expect(store_page.friday_hours.text).to have_text("1:30 PM") 
		expect(store_page.friday_hours.text).to have_text("11:30 PM") 		
		
		expect(store_page.saturday_hours.text).to have_text("2:45 PM") 
		expect(store_page.saturday_hours.text).to have_text("11:45 PM") 		

		# close every other day
		store_page.edit_hours_link.click

		store_page.store_sundayclosed.set true
		store_page.store_tuesdayclosed.set true
		store_page.store_thursdayclosed.set true
		store_page.store_saturdayclosed.set true

		store_page.save_store_hours_button.click

		# verify 
		expect(store_page.sunday_hours.text).to have_text("Closed") 		

		expect(store_page.monday_hours.text).to have_text("2:30 AM") 
		expect(store_page.monday_hours.text).to have_text("2:45 PM") 
		
		expect(store_page.tuesday_hours.text).to have_text("Closed") 		
		
		expect(store_page.wednesday_hours.text).to have_text("10:00 AM") 
		expect(store_page.wednesday_hours.text).to have_text("8:15 PM") 

		expect(store_page.thursday_hours.text).to have_text("Closed") 		
		
		expect(store_page.friday_hours.text).to have_text("1:30 PM") 
		expect(store_page.friday_hours.text).to have_text("11:30 PM") 		
		
		expect(store_page.saturday_hours.text).to have_text("Closed") 

		# reverse everyday
		store_page.edit_hours_link.click

		store_page.store_sundayclosed.set false
		store_page.store_mondayclosed.set true
		store_page.store_tuesdayclosed.set false
		store_page.store_wednesdayclosed.set true
		store_page.store_thursdayclosed.set false
		store_page.store_fridayclosed.set true
		store_page.store_saturdayclosed.set false
		
		store_page.save_store_hours_button.click

		# verify 
		expect(store_page.sunday_hours.text).to have_text("1:15 AM") 
		expect(store_page.sunday_hours.text).to have_text("1:30 PM") 

		expect(store_page.monday_hours.text).to have_text("Closed") 		
		
		expect(store_page.tuesday_hours.text).to have_text("3:45 AM") 
		expect(store_page.tuesday_hours.text).to have_text("3:00 PM") 
		
		expect(store_page.wednesday_hours.text).to have_text("Closed") 		

		expect(store_page.thursday_hours.text).to have_text("11:15 AM") 
		expect(store_page.thursday_hours.text).to have_text("9:15 PM") 
		
		expect(store_page.friday_hours.text).to have_text("Closed") 		
		
		expect(store_page.saturday_hours.text).to have_text("2:45 PM") 
		expect(store_page.saturday_hours.text).to have_text("11:45 PM") 	

	end
end
