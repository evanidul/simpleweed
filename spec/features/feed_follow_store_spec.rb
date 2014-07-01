require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/store_items'
require 'pages/search_results_stores'
require 'pages/store_search_preview'
require 'pages/registration'
require 'pages/store_claim'
require 'pages/profile_feed'

feature "review a store" , :js => true, :search =>true do

  	before :each do
	    if ENV['TARGETBROWSER'] == "chrome"
	      Capybara.register_driver :selenium do |app|
	        Capybara::Selenium::Driver.new(app, :browser => :chrome)
	    end

        page.driver.browser.manage.window.resize_to(1366,768)  #http://www.rapidtables.com/web/dev/screen-resolution-statistics.htm
  	end
  	end


	before :each do
		StoreItem.remove_all_from_index!
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

		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.save			
		
		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit

	end
	
	scenario "login, follow a store, should see success message, update store announcement, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

    	# announcement
		expect(store_page.announcement.text).to have_text("none.")
		store_page.edit_announcement_link.click
		new_announcement = "My New announcement"
		store_page.announcement_input.set new_announcement
		store_page.save_announcement_button.click
		expect(store_page.announcement.text).to have_text(new_announcement)

		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_announcement_updates.size.should == 1
		profile_feed.store_announcement_updates.map {|body| body.text}.should have_text "has a new announcement"


	end

	scenario "login, follow a store, should see success message, update store description, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

    	# check has default description
		expect(store_page.description.text).to have_text("none.")    					
		store_page.description_edit_link.click
		
		# change description
		new_description = "My New Description"
		store_page.store_description_input.set new_description	
		store_page.save_store_description_button.click
		expect(store_page.description.text).to have_text(new_description)   

		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_description_updates.size.should == 1
		profile_feed.store_description_updates.map {|body| body.text}.should have_text "has updated it's store description"
	end

	scenario "login, follow a store, should see success message, update store daily specials, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

    	# daily specials
		specials_default_value = "none."		
		expect(store_page.dailyspecials_sunday_text.text).to have_text(specials_default_value)    			

		store_page.edit_daily_specials_link.click
		store_page.dailyspecials_sunday_input.set "Sunday's Special"
		store_page.save_store_daily_specials_button.click
	
		expect(store_page.dailyspecials_sunday_text.text).to have_text("Sunday's Special")    			
		
		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_dailyspecials_updates.size.should == 1
		profile_feed.store_dailyspecials_updates.map {|body| body.text}.should have_text "has updated daily specials."
	end

	scenario "login, follow a store, should see success message, update store hours, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

		# update store hours
		store_page.edit_hours_link.click

		sunday_open_h = "01"
		sunday_open_m = "15"
		sunday_close_h = "13"
		sunday_close_m = "30"

		#store_page.date_storehourssundayopenhour.find("option[value='12']").select_option
		store_page.date_storehourssundayopenhour.find("option[value='" + sunday_open_h +"']").select_option
		store_page.date_storehourssundayopenminute.find("option[value='" + sunday_open_m +"']").select_option
		store_page.date_storehourssundayclosehour.find("option[value='" + sunday_close_h +"']").select_option
		store_page.date_storehourssundaycloseminute.find("option[value='" + sunday_close_m +"']").select_option

		store_page.save_store_hours_button.click 

		# verify 
		expect(store_page.sunday_hours.text).to have_text("1:15 AM") 
		expect(store_page.sunday_hours.text).to have_text("1:30 PM") 

		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_hours_updates.size.should == 1
		profile_feed.store_hours_updates.map {|body| body.text}.should have_text "has updated it's store hours."
	end

	scenario "login, follow a store, should see success message, update ftp, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

    	# update ftp
		store_page.edit_first_time_patient_deals_link.click
		new_ftpd = "No new deals today!"
		store_page.first_time_patient_deals_input.set new_ftpd
		store_page.save_first_time_patient_deals_button.click
		expect(store_page.first_time_patient_deals_text.text).to have_text(new_ftpd)    	
		store_page.firsttimepatientdeals.should be_checked
		
		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_ftp_updates.size.should == 1
		profile_feed.store_ftp_updates.map {|body| body.text}.should have_text "has updated it's first time patient deals"
	end

	scenario "login, follow a store, should see success message, update contact/address, see on feed" do	
		# login as admin
		page.visit("/")
		
		header = HeaderPageComponent.new
		header.has_loginlink?
		header.loginlink.click
    	
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click    	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

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

		# view profile
		header.edituserlink.click
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.store_contact_updates.size.should == 1
		profile_feed.store_contact_updates.map {|body| body.text}.should have_text "has updated it's contact information and address."
	end	

	# don't login, try to follow, get login prompt
	scenario "find a store, follow a store, get login prompt, login, follow a store , should see success message" do
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click

    	# should see login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)

		# should still be on store page
		expect(store_page.name_header.text).to have_text(@store_name)

		# follow store
    	store_page.follow_store_button.click  
    	wait_for_ajax  	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

    	# view profile your profile
		header.edituserlink.click		
		feeditem4 = "evanidul followed " + @store_name
		expect(page).to have_text(feeditem4) 
	end


end