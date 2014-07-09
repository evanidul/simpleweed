require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/store_items'
require 'pages/search_results_stores'
require 'pages/store_search_preview'
require 'pages/registration'
require 'pages/store_claim'
require 'pages/profile_feed'
require 'pages/profile_activity_page'
require 'pages/itempopup'
require 'pages/search_results_items'

feature "things that trigger item review feed items" , :js => true, :search =>true do

  	before :each do
	    if ENV['TARGETBROWSER'] == "chrome"
	      Capybara.register_driver :selenium do |app|
	        Capybara::Selenium::Driver.new(app, :browser => :chrome)
	    end

        page.driver.browser.manage.window.resize_to(1366,768)  #http://www.rapidtables.com/web/dev/screen-resolution-statistics.htm
  	end
  	end


	before :each do
		StoreItem.remove_all_from_index!
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

		@user2email = "user2@gmail.com"
        @user2password = "password"
        @user2username = "user2"
        user2 = User.new(:email => @user2email, :password => @user2password, :password_confirmation => @user2password, :username => @user2username)
        user2.skip_confirmation!        
        user2.save

		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.save			
		
        @item1_name = "og"
		@item1 =  @store.store_items.create(:name => @item1_name , :strain =>"indica")		
        @item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit

	end
	
    

	scenario "if you follow store, store item and user, and that user writes a review, it should only yield 1 feed item" do
		# search for it		
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	# follow store
    	store_page.follow_store_button.click

    	# should see login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)

		# should still be on store page
		expect(store_page.name_header.text).to have_text(@store_name)

		# follow store
    	store_page.follow_store_button.click  
    	wait_for_ajax  	
    	expect(store_page.flash_notice.text).to have_text ("this store has been favorited")

        # search for it     
        header = HeaderPageComponent.new    
        header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.item_query_input.set @item1_name
        header.search_button.click

        search_results_page = SearchResultsItemPageComponent.new        
                
        search_results_page.searchresults_item_names.size.should == 1
        search_results_page.searchresults_item_names.map {|name| name.text}.should == [@item1_name]

        # click and view preview        
        search_results_page.searchresults_item_names.first.click
        
        itempopup = ItemPopupComponent.new
        wait_for_ajax
        assert_modal_visible
        itempopup.tab_reviews.click

        # follow the item
        itempopup.follow_item_button.click
        itempopup.cancel_button.click

    	# logout
        header.logoutlink.click
        header.loginlink.click

    	# login modal
    	header.username.set @user2email
    	header.password.set @user2password
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@user2username)
		
        # search for it     
        header = HeaderPageComponent.new    
        header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.item_query_input.set @item1_name
        header.search_button.click

        search_results_page = SearchResultsItemPageComponent.new        
                
        search_results_page.searchresults_item_names.size.should == 1
        search_results_page.searchresults_item_names.map {|name| name.text}.should == [@item1_name]

        # click and view preview        
        search_results_page.searchresults_item_names.first.click
        
        itempopup = ItemPopupComponent.new
        wait_for_ajax
        assert_modal_visible
        itempopup.tab_reviews.click

        itempopup.write_review_button.click
        review_text = "i loved this thing"
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click     	

		# logout
        header.logoutlink.click
        header.loginlink.click

    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)

		# view profile your profile
		header.edituserlink.click		
		feeditem =  @user2username + " reviewed " + @item1_name
				
		expect(page).to have_text(feeditem) 

		profile_feed_page = ProfileFeedPageComponent.new
		profile_feed_page.item_reviews.size.should == 1

		# follow the user who wrote the review (user 2)
		profile_feed_page.user_links.first.click		
        profile_activity_page = ProfileActivityPageComponent.new
        profile_activity_page.follow_user_button.click

        # view profile your profile
		header.edituserlink.click				

		# should not see duplicate store reviews for the same store + user combo
		profile_feed_page.item_reviews.size.should == 1

	end

end	