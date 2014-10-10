require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/search_results_stores'
require 'pages/subscription_page'

feature "plan one" , :js => true do

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

		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.plan_id = 1
		@store.save	
		
		# make store manager
	  	@storemanageremail = "storemanager@gmail.com"
	  	@storemanagerusername = "storemanager"
	  	@storemanagerpassword = "password"        
		store_manager_user = User.new(:email => @storemanageremail, :password => @storemanagerpassword, :password_confirmation => @storemanagerpassword, :username => @storemanagerusername)
		store_manager_user.skip_confirmation!
		store_manager_user.save
		role_service = Simpleweed::Security::Roleservice.new							
		role_service.addStoreOwnerRoleToStore(store_manager_user, @store)								


		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit


	end

	scenario "plan 1 cannot change store promo, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.promo_edit_link.click
		
		new_promo = "new promo"
		store_page.promo_input.set new_promo
		store_page.save_promo_button.click
		expect(store_page.store_promo).to have_text(new_promo)
	end

	scenario "plan 1 cannot change store announcement, but admin can" do
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_announcement_link.click

		new_announcement = "new stuff here"
		store_page.announcement_input.set new_announcement
		store_page.save_announcement_button.click
		expect(store_page.announcement).to have_text(new_announcement)

	end	

	scenario "plan 1 cannot change store business description, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.description_edit_link.click
		
		# change description
		new_description = "My New Description"
		store_page.store_description_input.set new_description
		store_page.has_save_store_description_button?
		store_page.save_store_description_button.click
		expect(store_page.description.text).to have_text(new_description)   
	end

	scenario "plan 1 cannot change dispensary features, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
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

	end

	scenario "plan 1 cannot change store avatar, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.store_avatar.click
		
		wait_for_ajax
		store_page.should have_save_store_avatar_button
	end

	scenario "plan 1 cannot change store ftp, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_first_time_patient_deals_link.click
		
		new_ftpd = "No new deals today!"
		store_page.first_time_patient_deals_input.set new_ftpd
		store_page.save_first_time_patient_deals_button.click
		expect(store_page.first_time_patient_deals_text.text).to have_text(new_ftpd)    	
		store_page.firsttimepatientdeals.should be_checked
	end

	scenario "plan 1 cannot change store daily specials, but admin can" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
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
	end
end
