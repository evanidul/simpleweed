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
require 'pages/search_results_items'


feature "store item edit and add" , :js => true, :search =>true  do

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
		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "fuck me molly" , :strain =>"sativa", :cultivation => "outdoor", :privatereserve => false)	
		@item2.save
		
		@item3 =  @store.store_items.create(:name => "haze wizard" , :strain =>"hybrid", :cultivation => "hydroponic", :topshelf => true)	
		@item3.save

		@item4 =  @store.store_items.create(:name => "SUPER haze wizard" , :strain =>"hybrid", :cultivation => "hydroponic", :topshelf => true)	
		@item4.save

		Sunspot.commit
		
	end

	scenario "check nav tabs, search by name" do		
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
		header.indica.set true
		header.indoor.set true
		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "og"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "haze"		
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item3.name, @item4.name]

	end

	scenario "search by description" do		
		@item5 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item5.description = "werg zip bang"
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "screaming turtle" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item6.description = "jesus loves you"
		@item6.save

		@item7 =  @store.store_items.create(:name => "crazy ninja" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item7.description = "jesus loves you"
		@item7.save
		
		Sunspot.commit

		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "werg"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name]

		# new search
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "jesus"		
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item6.name, @item7.name]

	end

end