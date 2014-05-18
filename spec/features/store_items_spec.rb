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
	end

	# saving a store and loading that store in store item menu page can lead to a race condition.  since store.save returns before
	# the db save/commit happens, it's possible for selenium to find(store_id) before the save is processed.  Therefore, we make 
	# this test a little lazy by reloading some other pages first.
	scenario "create a store, add some items" do		
		
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminusername)

		# search for it		
		home_page = HomePageComponent.new
		home_page.search_input.set "7110 Rock Valley Court, San Diego, CA"
		home_page.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	expect(search_results_page.firstSearchResult_store_name.text).to have_text(@store_name)

    	# click and view preview
    	search_results_page.firstSearchResult_store_name.click
    	expect(search_results_page.store_name.text).to have_text(@store_name)

    	store_search_preview_page = StoreSearchPreviewPage.new
    	store_search_preview_page.view_store.click
    	store_page = StorePage.new
    	store_page.has_name_header?


		# edit menu		
		store_page.edit_store_items.click

		items_page = StoreItemsPage.new
		expect(items_page.store_name.text).to have_text(@store_name)
		items_page.add_store_item_button.click

		# add new item
		item_name = "Weedy"
		item_description = "It's so weedy."
		item_thc = "5.2"
		item_cbd = "5.20"
		item_cbn = "5.200"
		item_costhalfgram = "10"
		item_costgram = "20"
		item_costeighth = "50"
		item_costquarter = "100"
		item_costhalfoz = "200"
		item_costoz = "400"

		items_page.store_item_name.set item_name
		items_page.store_item_description.set item_description
		items_page.thc.set item_thc
		items_page.cbd.set item_cbd		
		items_page.cbn.set item_cbn
		items_page.store_item_costhalfgram.set item_costhalfgram
		items_page.store_item_costonegram.set item_costgram
		items_page.store_item_costeighthoz.set item_costeighth
		items_page.store_item_costquarteroz.set item_costquarter
		items_page.store_item_costhalfoz.set item_costhalfoz
		items_page.store_item_costoneoz.set item_costoz

		items_page.save_store_item_button.click



  	end
  


end