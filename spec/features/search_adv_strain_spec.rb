require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/store_items'
require 'pages/search_results_stores'
require 'pages/store_search_preview.rb'

feature "store item edit and add" , :js => true do

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
		@store.save	

		# items		
		@item1 = StoreItem.new(:name => "og" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)	
		@item1.store = @store
		@item1.save
		@item2 = StoreItem.new(:name => "fuck me molly" , :strain =>"sativa", :cultivation => "outdoor", :privatereserve => false)	
		@item2.store = @store
		@item2.save
		@item3 = StoreItem.new(:name => "haze wizard" , :strain =>"hybrid", :cultivation => "hydroponic", :topshelf => true)	
		@item3.store = @store
		@item3.save
	end

	scenario "check nav tabs" do		
		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	expect(search_results_page.firstSearchResult_store_name.text).to have_text(@store_name)

    	# basic nav test
    	header.show_adv_search_button.click
		header.search_opt_strain_and_attr_tab_link.click
		header.search_opt_quantity_price_tab_link.click
		header.search_opt_item_category_tab_link.click
		header.search_opt_distance_tab_link.click
		header.search_opt_store_features_tab_link.click
		header.search_opt_lab_tab_link.click
		header.search_opt_reviews_tab_link.click

		# and back to strain filters
		header.search_opt_strain_and_attr_tab_link.click
		

	end


end