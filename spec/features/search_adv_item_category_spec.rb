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

	scenario "search : flower" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "bud"
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "flower"
		@item2.subcategory = "shake"
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "concentrate"
		@item3.subcategory = "wax"
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.bud.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.bud.set true
		header.shake.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name, @item2.name]
	end	

	scenario "search : flower & concentrate" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "flower"
		@item1.subcategory = "trim"
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "concentrate"
		@item2.subcategory = "wax"
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "concentrate"
		@item3.subcategory = "hash"
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.trim.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.trim.set true
		header.wax.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name, @item2.name]
	end	

	scenario "search : concentrate" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "concentrate"
		@item1.subcategory = "hash"
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "concentrate"
		@item2.subcategory = 'budder/earwax/honeycomb/supermelt'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "concentrate"
		@item3.subcategory = 'bubble hash/full melt/ice wax'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.hash.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.hash.set true
		header.budder_earwax_honeycomb.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name, @item2.name]
	end	
	scenario "search : concentrate 2" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "concentrate"
		@item1.subcategory = 'bubble hash/full melt/ice wax'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "concentrate"
		@item2.subcategory = 'iso hash'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "concentrate"
		@item3.subcategory = 'kief/dry sieve'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.bubblehash_fullmelt_icewax.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.bubblehash_fullmelt_icewax.set true
		header.ISOhash.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name, @item2.name]
	end	
	scenario "search : concentrate 3" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "concentrate"
		@item1.subcategory = 'kief/dry sieve'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "concentrate"
		@item2.subcategory = 'shatter/amberglass'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "concentrate"
		@item3.subcategory = 'scissor/finger hash'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.kief_drysieve.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.kief_drysieve.set false
		header.shatter_amberglass.set true
		header.scissor_fingerhash.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end		
	scenario "search : concentrate 4, edible" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "concentrate"
		@item1.subcategory = 'oil/cartridge'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "edible"
		@item2.subcategory = 'baked'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "edible"
		@item3.subcategory = 'candy/chocolate'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.oil_cartridge.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.oil_cartridge.set false
		header.baked.set true
		header.candy_chocolate.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end	
	scenario "search : edible 2" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "edible"
		@item1.subcategory = 'cooking'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "edible"
		@item2.subcategory = 'drink'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "edible"
		@item3.subcategory = 'frozen'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.cooking.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.cooking.set false
		header.drink.set true
		header.frozen.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end	
	scenario "search : edible , prerolls" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "edible"
		@item1.subcategory = 'other_edible'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "pre-roll"
		@item2.subcategory = 'blunt'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "pre-roll"
		@item3.subcategory = 'joint'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.other_edibles.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.other_edibles.set false
		header.blunt.set true
		header.joint.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end		
	scenario "search : other" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "other"
		@item1.subcategory = 'clones'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "other"
		@item2.subcategory = 'seeds'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "other"
		@item3.subcategory = 'oral'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.clones.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.clones.set false
		header.seeds.set true
		header.oral.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end		
	scenario "search : accessory" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "other"
		@item1.subcategory = 'topical'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "accessory"
		@item2.subcategory = 'bong/pipe'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "accessory"
		@item3.subcategory = 'bong/pipe accessories'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.topical.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.topical.set false
		header.bong_pipe.set true
		header.bong_pipe_accessories.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end	
	scenario "search : accessory 2" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "accessory"
		@item1.subcategory = 'book/magazine'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "accessory"
		@item2.subcategory = 'butane/lighter'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "accessory"
		@item3.subcategory = 'cleaning'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.book_magazine.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.book_magazine.set false
		header.butane_lighter.set true
		header.cleaning.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end	
	scenario "search : accessory 3" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "accessory"
		@item1.subcategory = 'clothes'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "accessory"
		@item2.subcategory = 'grinder'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "accessory"
		@item3.subcategory = 'other_accessory'
		@item3.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.clothes.set true
		

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 1
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.clothes.set false
		header.grinder.set true
		header.other_accessories.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item2.name, @item3.name]
	end	
	scenario "search : accessory 4" do		
		@item1 =  @store.store_items.create(:name => "alfafla 1" , :strain =>"indica")		
		@item1.maincategory = "accessory"
		@item1.subcategory = 'paper/wrap'
		@item1.save
		
		@item2 =  @store.store_items.create(:name => "alfafla 2" , :strain =>"indica")		
		@item2.maincategory = "accessory"
		@item2.subcategory = 'storage'
		@item2.save

		@item3 =  @store.store_items.create(:name => "alfafla 3" , :strain =>"indica")		
		@item3.maincategory = "accessory"
		@item3.subcategory = 'vape'
		@item3.save		

		@item4 =  @store.store_items.create(:name => "alfafla 4" , :strain =>"indica")		
		@item4.maincategory = "accessory"
		@item4.subcategory = 'vape accessories'
		@item4.save		

		Sunspot.commit

		# new search
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfafla"		
		header.show_adv_search_button.click	
		header.search_opt_item_category_tab_link.click	
		header.paper_wrap.set true
		header.storage.set true

		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item1.name, @item2.name]

		# new search for hybrid
		header.show_adv_search_button.click		
		header.search_opt_item_category_tab_link.click
		header.paper_wrap.set false
		header.storage.set false
		header.vape.set true
		header.vape_accessories.set true
		
		header.search_button.click
		# setting false in the UI doesn't mean filter for false, it means all values (T or F) are acceptable values
		searchresults_page.searchresults_item_names.size.should == 2
		searchresults_page.searchresults_item_names.map {|name| name.text}.should == [@item3.name, @item4.name]
	end		
end	