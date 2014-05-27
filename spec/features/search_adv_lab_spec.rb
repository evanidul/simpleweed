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

	scenario "search by lab%" do		
		@item1 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item1.thc = 4
		@item1.cbd = 4
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfalfa 2" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item2.thc = 3.4
		@item2.cbn = 3.4
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfalfa 3" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item3.thc = 6.3
		@item3.cbn = 6.3
		@item3.save

		Sunspot.commit
	
		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfalfa"		
		header.show_adv_search_button.click	
		header.search_opt_lab_tab_link.click	
		header.thc_lessthanfive.set true
	

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name, @item2.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_lab_tab_link.click
		header.thc_none.set true
		header.cbd_lessthanfive.set true
	
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 3
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name, @item2.name, @item3.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_lab_tab_link.click
		header.thc_none.set true
		header.cbd_none.set true
		header.cbn_lessthanfive.set true
	
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name, @item2.name]
	end
	scenario "search by lab% : 5-10" do		
		@item1 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item1.thc = 6
		@item1.cbd = 6
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfalfa 2" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item2.thc = 6.7
		@item2.cbn = 6.7
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfalfa 3" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item3.thc = 10.1
		@item3.cbn = 20
		@item3.save

		Sunspot.commit
	
		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfalfa"		
		header.show_adv_search_button.click	
		header.search_opt_lab_tab_link.click	
		header.thc_fivetoten.set true
	

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name, @item2.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_lab_tab_link.click
		header.thc_none.set true
		header.cbd_fivetoten.set true
	
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_lab_tab_link.click
		header.thc_none.set true
		header.cbd_none.set true
		header.cbn_fivetoten.set true
	
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item2.name]
	end
end	