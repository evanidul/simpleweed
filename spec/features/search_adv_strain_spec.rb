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


feature "search adv by strain" , :js => true, :search =>true  do

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

		StoreItem.remove_all_from_index! 
		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.save	
		
	end

	scenario "check nav tabs, search by name" do		

		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "fuck me molly" , :strain =>"sativa")	
		@item2.save
		
		@item3 =  @store.store_items.create(:name => "haze wizard" , :strain =>"hybrid")	
		@item3.save

		@item4 =  @store.store_items.create(:name => "SUPER haze wizard" , :strain =>"hybrid")	
		@item4.save

		Sunspot.commit

		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

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
		
		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "og"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.show_adv_search_button.click
		header.search_opt_strain_and_attr_tab_link.click
		header.indica.set false
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

	scenario "search : indica or sativa" do		
		@item5 =  @store.store_items.create(:name => "alfafla" , :cultivation => "indoor", :privatereserve => true)		
		@item5.strain = "indica"
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :cultivation => "indoor", :privatereserve => true)		
		@item6.strain = "sativa"
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :cultivation => "indoor", :privatereserve => true)		
		@item7.strain = "hybrid"
		@item7.save
		
		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.indica.set true
		header.sativa.set true

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new		
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.indica.set false
		header.sativa.set false
		header.hybrid.set true
		header.search_button.click
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item7.name]
	end
	
	scenario "search : cultivation" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica",  :privatereserve => true)		
		@item5.cultivation = "indoor"
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica",  :privatereserve => true)		
		@item6.cultivation = "outdoor"
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica",  :privatereserve => true)		
		@item7.cultivation = "hydroponic"
		@item7.save
		
		@item8 =  @store.store_items.create(:name => "alfafla 4" , :strain =>"indica", :privatereserve => true)		
		@item8.cultivation = "greenhouse"
		@item8.save

		@item9 =  @store.store_items.create(:name => "alfafla 5" , :strain =>"indica", :privatereserve => true)				
		@item9.save

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.indoor.set true
		header.outdoor.set true

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new		
		searchresults_page.searchresults_store_names.size.should == 2
		# item9 doesn't have cultivation set, and nil values return in the search results...for now.
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.indoor.set false
		header.outdoor.set false
		header.hydroponic.set true
		header.greenhouse.set true		
		
		header.search_button.click
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item7.name, @item8.name]
	end
	scenario "search : privatereserve" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.privatereserve = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.privatereserve = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.privatereserve = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.privatereserve.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badge?
		searchresults_page.badge_privatereserve.size.should == 2

		# new search for hybrid
		header.show_adv_search_button.click		
		header.privatereserve.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end
	scenario "search : topshelf" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.topshelf = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.topshelf = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.topshelf = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.topshelf.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badges?
		searchresults_page.badge_topshelf.size.should == 2		

		# new search for hybrid
		header.show_adv_search_button.click		
		header.topshelf.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end
	scenario "search : glutenfree" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.glutenfree = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.glutenfree = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.glutenfree = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.glutenfree.set true

		# badges?
		searchresults_page.badge_glutenfree.size.should == 2		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.glutenfree.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end
	scenario "search : sugarfree" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.sugarfree = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.sugarfree = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.sugarfree = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.sugarfree.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badges?
		searchresults_page.badge_sugarfree.size.should == 2

		# new search for hybrid
		header.show_adv_search_button.click		
		header.sugarfree.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end	
	scenario "search : organic" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.organic = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.organic = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.organic = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.organic.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badges?
		searchresults_page.badge_organic.size.should == 2

		# new search for hybrid
		header.show_adv_search_button.click		
		header.organic.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end		
	scenario "search : og" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.og = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.og = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.og = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.og.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badges?
		searchresults_page.badge_og.size.should == 2

		# new search for hybrid
		header.show_adv_search_button.click		
		header.og.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end	
	scenario "search : kush" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.kush = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.kush = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.kush = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.kush.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]

		# badges?
		searchresults_page.badge_kush.size.should == 2

		# new search for hybrid
		header.show_adv_search_button.click		
		header.kush.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end	
	scenario "search : haze" do		
		@item5 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item5.haze = true
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item6.haze = true
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item7.haze = false
		@item7.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click		
		header.haze.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name]
		# badges?
		searchresults_page.badge_haze.size.should == 2
		# new search for hybrid
		header.show_adv_search_button.click		
		header.haze.set false
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name, @item6.name,@item7.name]
	end	
end