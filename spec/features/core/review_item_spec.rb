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
require 'page_components/profile_nav'
require 'page_components/community_nav'
require 'pages/profile_myreviews'
require 'pages/community_recent_item_reviews'

feature "store item reviews" , :js => true, :search =>true do

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
        @store.plan_id = 5
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

    scenario "log on and write a review with default 1 star, go to profile and see review in my reviews, see in com recent item reviews" do
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
        itempopup.cancel_button.click    
        
        # go to your profile        
        page.visit("/")
        header.edituserlink.click           
        profile_nav = ProfileNavPageComponent.new
        profile_nav.my_reviews_link.click

        myreviews_page = ProfileMyReviewsPageComponent.new
        myreviews_page.item_review_tab.click
        myreviews_page.item_reviews.size.should == 1      

        # go to recent item reviews in comm, it should be there        
        header.community_home_link.click
        community_nav = CommunityNavPageComponent.new
        community_nav.recent_item_reviews_link.click
        community_recent_item_reviews_page = CommunityRecentItemReviewsPageComponent.new
        community_recent_item_reviews_page.recent_item_reviews.size.should == 1

        # search for it 
        page.visit("/")
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

    scenario "log on and write a review, choose 1 star" do
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
        itempopup.onestar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
                

        # search for it           
        page.visit("/")
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

    scenario "log on and write a review, choose 2 star" do
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
        itempopup.twostar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
        

        # search for it     
        page.visit("/")
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("2")       

    end

    scenario "log on and write a review, choose 3 star" do
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
        itempopup.threestar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
        

        # search for it 
        page.visit("/")
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("3")       

    end

    scenario "log on and write a review, choose 4 star" do
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
        itempopup.fourstar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
        

        # search for it     
        page.visit("/")
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("4")       

    end

    scenario "log on and write a review, choose 5 star" do
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
        itempopup.fivestar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
        

        # search for it    
        page.visit("/")
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("5")       

    end

    scenario "logged out, try to review, fill out login modal, write review" do
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

        # expect login modal, since you can't write a review unless you're logged in
        # login modal
        wait_for_ajax
        assert_modal_visible
        header.username.set @adminemail
        header.password.set @adminpassword
        header.logininbutton.click

        expect(header.edituserlink.text).to have_text(@adminusername)

        # should still be on the same search page, since login redirects us back
        search_results_page.searchresults_item_names.size.should == 1
        search_results_page.searchresults_item_names.map {|name| name.text}.should == [@item1_name]

        # click and view preview        
        search_results_page.searchresults_item_names.first.click     
        wait_for_ajax
        assert_modal_visible
        itempopup.tab_reviews.click
        itempopup.write_review_button.click
        review_text = "i loved this thing"    
        itempopup.fivestar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click
        

        # search for it
        page.visit("/")    
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("5")  

    end

    scenario "write a review, go back to store page, hit review button, should see tooltip" do
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
        itempopup.fourstar_button.click
        itempopup.review_text_input.set review_text
        itempopup.save_review_button.click
        itempopup.cancel_button.click        

        # search for it   
        page.visit("/")
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
        expect(itempopup.star_ranking.first['star-value']).to have_text("4")    

        # try and review again, should get tooltip        
        itempopup.write_review_button_blocked.click       
        expect(itempopup.write_review_button_blocked_tooltip).to have_text("you've already reviewed this item") 

    end

    scenario "claim a store, then try to write a review for it, see tooltip saying you can't review your own store" do      
        
        @store.email = @adminemail        
        @store.save

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
        header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

        search_results_page = SearchResultsStoresPageComponent.new                      
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

        # click and view preview
        search_results_page.search_results_store_names.first.click
        
        store_page = StorePage.new      
        expect(store_page.name_header.text).to have_text(@store_name)    
        store_page.claim_store_button.click

        store_claim_page = StoreClaimPage.new
        expect(store_claim_page.name_header.text).to have_text(@store_name)
        store_claim_page.claim_store_button.click       
        
        expect(page).to have_text("You have successfully claimed this store.")          
        
        expect(store_page.edit_links_tip.text).to have_text("edit links are now available for you")
        store_has_claim_button = store_page.has_claim_store_button?        
        assert_equal( false, store_has_claim_button, 'Store should not have a claim button after it is claimed')

        # search for it     
        header = HeaderPageComponent.new    
        header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.item_query_input.set @item1_name
        header.search_button.click

        search_results_page = SearchResultsItemPageComponent.new        
                
        search_results_page.searchresults_item_names.size.should == 1
        search_results_page.searchresults_item_names.map {|name| name.text}.should == [@item1_name]

        # click and view preview        
        itempopup = ItemPopupComponent.new
        search_results_page.searchresults_item_names.first.click
        wait_for_ajax
        assert_modal_visible        
        itempopup.tab_reviews.click

        # try and review again, should get tooltip        
        itempopup.write_review_button_blocked.click       
        expect(itempopup.write_review_button_blocked_tooltip).to have_text("store managers cannot review items") 



    end
	
end