require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/homepage'
require 'pages/store_items'
require 'pages/search_results_stores'
require 'pages/search_results_items'
require 'pages/store_search_preview'
require 'pages/registration'
require 'pages/store_claim'
require 'pages/itempopup'

feature "store item edit and add" , :js => true, :search =>true do

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

	
	scenario "no reviews for store, should see prompt to be first" do	
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

		# tooltip there?    	
    	expect(itempopup.be_the_first.text).to have_text("no reviews yet")       
	end

    scenario "log on and write a review with default 1 star" do
        # login as admin
        page.visit("/")
        
        header = HeaderPageComponent.new
        header.has_loginlink?
        header.loginlink.click
        
        # login modal
        header.username.set @adminemail
        header.password.set @adminpassword
        header.logininbutton.click

        expect(header.edituserlink.text).to have_text(@adminusername)
        
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
        wait_for_ajax
        assert_modal_visible        
        itempopup.tab_reviews.click

        # review should be there
        expect(itempopup.review_content.first.text).to have_text(review_text)
        expect(itempopup.star_ranking.first['star-value']).to have_text("1")       

    end

	
end