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
require 'pages/search_results_items'
require 'pages/itempopup'
require 'pages/profile_activity_page'
require 'page_components/profile_nav'
require 'pages/profile_following'

feature "follow users" , :js => true, :search =>true do

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

		# create some reviews
		@item1_user1_reviex_text = "item1_user1_review_text"
		@item1_user1_reviex_stars = 3
		@item1_user1_review =  @item1.store_item_reviews.new(:review => @item1_user1_reviex_text, :user =>user, :stars => @item1_user1_reviex_stars)
		@item1_user1_review.save

		Sunspot.commit

	end
	
	scenario "find a store, review it, log on as someone else, follow that person, see that you are following that person in feed, see their review, unfollow the user" do
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

        # review should be there        
        expect(itempopup.review_content.first.text).to have_text(@item1_user1_reviex_text)        
        expect(itempopup.star_ranking.first['star-value']).to have_text(@item1_user1_reviex_stars.to_s)  

        # you can comment on your reviews
        user1_firstcomment = "user1_firstcomment"
        itempopup.new_comment_inputs.first.set user1_firstcomment
        itempopup.save_new_comment_button.first.click
        wait_for_ajax                
        expect(itempopup.item_review_comments.first).to have_text(user1_firstcomment) 
        itempopup.cancel_button.click

        # logout
        header.logoutlink.click
        header.loginlink.click

        # login as user 2        
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

        # review should be there        
        expect(itempopup.review_content.first.text).to have_text(@item1_user1_reviex_text)
        expect(itempopup.star_ranking.first['star-value']).to have_text(@item1_user1_reviex_stars.to_s) 

        # first comment should be there
        expect(itempopup.item_review_comments.first).to have_text(user1_firstcomment) 

        # click on the username link for the first review
        itempopup.user_links.first.click

        # follow that user
        profile_activity_page = ProfileActivityPageComponent.new

        profile_activity_page.follow_user_button.click

        # view profile your profile
		header.edituserlink.click		
		profile_feed = ProfileFeedPageComponent.new

		wait_for_ajax
		profile_feed.user_following_user_feed_items.size.should == 1
		profile_feed.user_following_user_feed_items.map {|body| body.text}.should have_text @user2username + " is following " + @adminusername

		# user's review and comment are also in the feed, test as well...
		
		feeditem2 = "evanidul commented on the review of og"
		feeditem3 = "evanidul reviewed og"
		expect(page).to have_text(feeditem2) 
		expect(page).to have_text(feeditem3) 

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

        # view profile your profile
		header.edituserlink.click		
		feeditem4 = "user2 followed og"
		expect(page).to have_text(feeditem4) 

        # unfollow user
        profile_nav = ProfileNavPageComponent.new
        profile_nav.following_link.click

        following_page = ProfileFollowingPageComponent.new
        following_page.followed_users.size.should == 1

        following_page.unfollow_user_buttons.size.should == 1
        following_page.unfollow_user_buttons.first.click
        wait_for_ajax

        following_page.unfollow_user_buttons.size.should == 0
        following_page.follow_user_buttons.size.should == 1

        # follow user again
        following_page.follow_user_buttons.first.click
        wait_for_ajax

        following_page.unfollow_user_buttons.size.should == 1
        following_page.follow_user_buttons.size.should == 0      

	end


end