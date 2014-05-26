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
		
		
	end

	scenario "search : store filters" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.deliveryservice = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.acceptscreditcards = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.deliveryservice.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.deliveryservice.set false
		header.acceptsatmcredit.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters atm access dispensingmachines" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.atmaccess = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.automaticdispensingmachines = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.atmaccess.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.atmaccess.set false
		header.dispensingmachines.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters ftp handicap" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.firsttimepatientdeals = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.handicapaccess = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.firsttimepatientdeals.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.firsttimepatientdeals.set false
		header.handicapaccess.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters lounge area" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.loungearea = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.petfriendly = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.loungearea.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.loungearea.set false
		header.pet_friendly.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters security guard eighteen" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.securityguard = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.eighteenplus = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.security_guard.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.security_guard.set false
		header.eighteenplus.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters twenty has photos" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.twentyoneplus = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.hasphotos = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.twentyoneplus.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.twentyoneplus.set false
		header.hasphotos.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
	scenario "search : store filters lab tested onsite testing" do	
		@store1_name = "My new store"
		@store1_addressline1 = "7110 Rock Valley Court"
		@store1_city = "San Diego"
		@store1_ca = "CA"
		@store1_zip = "92122"
		@store1 = Store.new(:name => @store1_name , :addressline1 => @store1_addressline1, :city => @store1_city, :state => @store1_ca, :zip => @store1_zip)
		
		@store1.labtested = true

		@store1.save	
		@item1 =  @store1.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save

		@store2_name = "My new store"
		@store2_addressline1 = "7110 Rock Valley Court"
		@store2_city = "San Diego"
		@store2_ca = "CA"
		@store2_zip = "92122"
		@store2 = Store.new(:name => @store2_name , :addressline1 => @store2_addressline1, :city => @store2_city, :state => @store2_ca, :zip => @store2_zip)
		
		@store2.onsitetesting = true

		@store2.save	
		@item2 =  @store2.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "bud"
		@item2.save


		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_store_features_tab_link.click	
		header.labtested.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_store_features_tab_link.click
		header.labtested.set false
		header.onsitetesting.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
end