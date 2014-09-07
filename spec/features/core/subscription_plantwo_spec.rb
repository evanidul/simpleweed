require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/search_results_stores'
require 'pages/subscription_page'

feature "plan two" , :js => true do

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
		@store.plan_id = 2
		@store.save	

		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit


	end

	scenario "plan 2 can change store promo" do
				
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

	scenario "plan 2 can change business description" do
				
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

	scenario "plan 2 can change dispensary features" do
				
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

end