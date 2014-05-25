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


feature "search adv by price" , :js => true, :search =>true  do

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
		StoreItem.remove_all_from_index! 
		# @item1 =  @store.store_items.create(:name => "og" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		# @item1.save
		
		# @item2 =  @store.store_items.create(:name => "fuck me molly" , :strain =>"sativa", :cultivation => "outdoor", :privatereserve => false)	
		# @item2.save
		
		# @item3 =  @store.store_items.create(:name => "haze wizard" , :strain =>"hybrid", :cultivation => "hydroponic", :topshelf => true)	
		# @item3.save

		# @item4 =  @store.store_items.create(:name => "SUPER haze wizard" , :strain =>"hybrid", :cultivation => "hydroponic", :topshelf => true)	
		# @item4.save

		# Sunspot.commit
		
	end

	scenario "search by price" do		
		@item5 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item5.costhalfgram = 5
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfalfa 2" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item6.costonegram = 20
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfalfa 3" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item7.costeighthoz = 50
		@item7.save

		@item8 =  @store.store_items.create(:name => "alfalfa 4" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item8.costquarteroz = 100
		@item8.save

		@item9 =  @store.store_items.create(:name => "alfalfa 5" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item9.costhalfoz = 200
		@item9.save

		@item10 =  @store.store_items.create(:name => "alfalfa 6" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item10.costoneoz = 400
		@item10.save
		
		Sunspot.commit

		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfalfa"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 6		

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 4
		header.search_maxprice.set 6
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_gram.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 19
		header.search_maxprice.set 21
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item6.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_eighth.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 49
		header.search_maxprice.set 51
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item7.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_quarteroz.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 99
		header.search_maxprice.set 101
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item8.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfoz.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 199
		header.search_maxprice.set 201
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item9.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_oz.set true
		header.search_pricerangeselect_custom.set true
		header.search_minprice.set 399
		header.search_maxprice.set 401
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item10.name]

	end


	scenario "search by price, price categories" do		
		@item5 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item5.costhalfgram = 5
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfalfa 2" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item6.costhalfgram = 35
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfalfa 3" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item7.costhalfgram = 55
		@item7.save

		@item8 =  @store.store_items.create(:name => "alfalfa 4" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item8.costhalfgram = 105
		@item8.save

		@item9 =  @store.store_items.create(:name => "alfalfa 5" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item9.costhalfgram = 205
		@item9.save

		@item10 =  @store.store_items.create(:name => "alfalfa 6" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item10.costhalfgram = 35
		@item10.save
		
		Sunspot.commit

		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfalfa"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 6		

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_lessthan25.set true
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item5.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_between25and50.set true
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 2
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item6.name, @item10.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_between50and100.set true
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item7.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_between100and200.set true
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item8.name]

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_halfgram.set true
		header.search_pricerangeselect_morethan200.set true
		header.search_button.click

		searchresults_page.searchresults_store_names.size.should == 1
		searchresults_page.searchresults_store_names.map {|name| name.text}.should == [@item9.name]


	end

	scenario "search by price:none selected" do		
		@item5 =  @store.store_items.create(:name => "alfalfa" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item5.costhalfgram = 5
		@item5.save
		
		@item6 =  @store.store_items.create(:name => "alfalfa 2" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item6.costonegram = 20
		@item6.save

		@item7 =  @store.store_items.create(:name => "alfalfa 3" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item7.costeighthoz = 50
		@item7.save

		@item8 =  @store.store_items.create(:name => "alfalfa 4" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item8.costquarteroz = 100
		@item8.save

		@item9 =  @store.store_items.create(:name => "alfalfa 5" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item9.costhalfoz = 200
		@item9.save

		@item10 =  @store.store_items.create(:name => "alfalfa 6" , :strain =>"indica", :cultivation => "indoor", :privatereserve => true)		
		@item10.costoneoz = 400
		@item10.save
		
		Sunspot.commit

		# search for it
		page.visit("/users/sign_in")
		header = HeaderPageComponent.new		
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
		header.item_query_input.set "alfalfa"		
		header.search_button.click

		searchresults_page = SearchResultsItemPageComponent.new
		searchresults_page.searchresults_store_names.size.should == 6		

		# filter by price
		header.show_adv_search_button.click
		header.search_opt_quantity_price_tab_link.click

		header.search_filterpriceby_.set true # no quantity selected
		header.search_pricerangeselect_.set true #no price range selected

		searchresults_page.searchresults_store_names.size.should == 6		

	end
end