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

	scenario "plan 1 cannot change store promo" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.promo_edit_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end

	scenario "plan 1 cannot change business description" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.description_edit_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end

	scenario "plan 1 cannot change dispensary features" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_features_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end

	scenario "plan 1 cannot change store avatar" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.store_avatar.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end

	scenario "plan 1 cannot change first time patient deals" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_first_time_patient_deals_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end

	scenario "plan 1 cannot change daily specials" do
				
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_daily_specials_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end
	
	scenario "plan 1 cannot change announcements" do
		page.visit("/users/sign_in")
		login_page = LoginPage.new

		login_page.username_input.set @storemanagerusername
    	login_page.username_password_input.set @storemanagerpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
    	expect(header.edituserlink.text).to have_text(@storemanagerusername)

		# go to store
		page.visit(store_path(@store))		
    	
    	store_page = StorePage.new    	
		expect(store_page.name_header.text).to have_text(@store_name)    			
		
		store_page.edit_announcement_link.click
		
		# expect subscription page
		expect(page).to have_title "subscription plans"
	end
end
