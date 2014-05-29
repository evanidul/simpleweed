require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/search_results_stores'
require 'pages/store_items'

feature "search page" , :js => true , :search =>true do

    before :each do
        if ENV['TARGETBROWSER'] == "chrome"
          Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :chrome)
        end
        page.driver.browser.manage.window.resize_to(1366,768)  #http://www.rapidtables.com/web/dev/screen-resolution-statistics.htm
        # page.driver.browser.manage().window().maximize() 
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

	scenario "sign in as admin, create a new store, add an address, search for that address, see it in search results" do
		# setup a store		
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminusername
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	header = HeaderPageComponent.new
		header.has_edituserlink?
    	expect(header.edituserlink.text).to have_text(@adminusername)

    	stores_page = AdminStoresPage.new
    	stores_page.load
    	stores_page.has_newstore_button?    	
    	stores_page.newstore_button.click

    	store_name = "My New Store"
    	stores_page.modal_store_name_input.set store_name
    	stores_page.modal_save_button.click

    	store_page = StorePage.new
    	store_page.has_name_header?
		expect(store_page.name_header.text).to have_text(store_name)    	
		store_page.has_description?

		# change the address
		store_page.edit_contact_link.click
    	new_addressline1 = "7110 Rock Valley Court"
    	store_page.addressline1_input.set new_addressline1
    	new_addressline2 = "Apt. 506"
    	store_page.addressline2_input.set new_addressline2
    	new_city = "San Diego"	
    	store_page.city_input.set new_city
    	new_state = "CA"
    	store_page.state_input.set new_state
    	new_zip = "92122"
    	store_page.zip_input.set new_zip
    	new_phonenumber = "1-415-123-1234"
    	store_page.phonenumber_input.set new_phonenumber
    	new_email = "evanidul@gmail.com"
    	store_page.email_input.set new_email
    	new_website = "www.evanidul.com"
    	store_page.website_input.set new_website
    	new_fb = "www.facebook.com/mypage"
    	store_page.facebook_input.set new_fb
    	new_twitter = "www.twitter.com/asd"
    	store_page.twitter_input.set new_twitter
    	new_instagram = "www.instagram.com/asdf"
    	store_page.instagram_input.set new_instagram

    	store_page.save_store_contact_button.click

		expect(store_page.addressline1.text).to have_text(new_addressline1)    			
		expect(store_page.addressline2.text).to have_text(new_addressline2)    			
		expect(store_page.city.text).to have_text(new_city)    						
		expect(store_page.state.text).to have_text(new_state)    						
		expect(store_page.zip.text).to have_text(new_zip)    						

        # search is indexed by item, so stores won't be added to search until an item is added.
        store_page.edit_store_items.click
        items_page = StoreItemsPage.new
        items_page.add_store_item_button.click

        # add an item in menu edit page
        # add new item
        item_name = "Weedy"
        item_description = "It's so weedy."
        item_thc = "5.2"
        item_cbd = "5.20"
        item_cbn = "5.15"
        item_costhalfgram = "10"
        item_costgram = "20"
        item_costeighth = "50"
        item_costquarter = "100"
        item_costhalfoz = "200"
        item_costoz = "400"
        item_perunit = "10"

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
        items_page.store_item_costperunit.set item_perunit

        items_page.store_item_strain.select 'indica'
        items_page.store_item_maincategory.select 'flower'
        items_page.store_item_subcategory.select 'bud'

        items_page.save_store_item_button.click

        # back to item list
        expect(items_page.firstSearchResult_item_name.text).to have_text(item_name)

        # item is added, store should be in search index
        Sunspot.commit

		# search for it
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"        
        
		header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [store_name]
        #expect(search_results_page.firstSearchResult_store_name.text).to have_text(store_name)

    	# click and view preview
    	#search_results_page.firstSearchResult_store_name.click
    	#expect(search_results_page.store_name.text).to have_text(store_name)
	end	

	scenario "go to home page, search, nothing should render but an error mesg" do
		page.visit("/")
	   
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click
        
        searchresultspage = SearchResultsStoresPageComponent.new
		expect(searchresultspage.flash_warning.text).to have_text("Your search returned 0 results.")    						
	end

    scenario "go to home page, search with gibberish location, should not error and render message" do
        page.visit("/")
       
        header = HeaderPageComponent.new    
        header.search_input.set "asdfaslkdfjalkjwekfljwlkf"
        header.search_button.click
        
        searchresultspage = SearchResultsStoresPageComponent.new
        expect(searchresultspage.flash_warning.text).to have_text("Your search returned 0 results.")                            
    end
    scenario "go to home page, search with gibberish item query and no loc, should not error and render message" do
        page.visit("/")
       
        header = HeaderPageComponent.new    
        header.item_query_input.set "alsdkfjasdlkfj2l3kjflk23jf,ds.f,ms."
        header.search_button.click
        
        searchresultspage = SearchResultsStoresPageComponent.new
        expect(searchresultspage.flash_warning.text).to have_text("Your search returned 0 results.")                            
    end
end	