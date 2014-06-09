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

feature "store review comments" , :js => true, :search =>true do

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

        @user3email = "user3@gmail.com"
        @user3password = "password"
        @user3username = "user3"
        user3 = User.new(:email => @user3email, :password => @user3password, :password_confirmation => @user3password, :username => @user3username)
        user3.skip_confirmation!
        user3.save

		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.save	

		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit
	end

	
	scenario "login as a few users, create reviews, and comment on them" do
        # login as admin
        page.visit("/")        
        header = HeaderPageComponent.new        
        header.loginlink.click
        
        # login modal
        header.username.set @adminemail
        header.password.set @adminpassword
        header.logininbutton.click

        expect(header.edituserlink.text).to have_text(@adminusername)
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

        store_page.write_review_button.click
        store_page.cancel_write_review_button.click
        store_page.write_review_button.click
        review_text = "I hated this place!"
        store_page.review_text.set review_text
        store_page.save_review_button.click

        #expect success message
        expect(store_page.flash_notice.text).to have_text("Thank you")
        store_page.tabs_reviews.click                    
        expect(store_page.review_content.first.text).to have_text(review_text)
        expect(store_page.star_ranking.first['star-value']).to have_text("1") 

        # users can comment on their own reviews
        store_page.tabs_reviews.click
        user1comment = "selfless promotion"
        store_page.new_comment_inputs.first.set user1comment
        store_page.save_new_comment_button.first.click
        wait_for_ajax
        expect(store_page.store_review_comments.first).to have_text(user1comment) 
        

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
        header.search_button.click

        search_results_page = SearchResultsStoresPageComponent.new      
                
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

        # click and view preview
        search_results_page.search_results_store_names.first.click
        store_page = StorePage.new
        expect(store_page.name_header.text).to have_text(@store_name)
        
        # reviews tab
        store_page.tabs_reviews.click
        expect(store_page.review_content.first.text).to have_text(review_text)
        expect(store_page.star_ranking.first['star-value']).to have_text("1") 
        expect(store_page.review_vote_sum.first).to have_text("0")

        # user2 comments on user1's review
        store_page.tabs_reviews.click
        user2comment = "what a stupid comment!"
        store_page.new_comment_inputs.first.set user2comment
        store_page.save_new_comment_button.first.click
        wait_for_ajax        
        expect(store_page.store_review_comments.first).to have_text(user1comment) 
        expect(store_page.store_review_comments[1]).to have_text(user2comment) 
        

        # user 2 writes his own review
        store_page.write_review_button.click         
        review_text_user2 = "I loved this place!"
        store_page.review_text.set review_text_user2
        store_page.fivestar_button.click
        store_page.save_review_button.click

        #expect success message
        expect(store_page.flash_notice.text).to have_text("Thank you")
        store_page.tabs_reviews.click   

        # ordering is most recent on top, since vote total is 0 for both reviews
        expect(store_page.review_content.first.text).to have_text(review_text_user2)
        expect(store_page.star_ranking.first['star-value']).to have_text("5") 

        # logout
        header.logoutlink.click
        header.loginlink.click

        # login as user 3
        header.username.set @user3email
        header.password.set @user3password
        header.logininbutton.click        
        expect(header.edituserlink.text).to have_text(@user3username)

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
        
        # reviews tab
        store_page.tabs_reviews.click
        
        # votes still 0 for both reviews, so user2's review is top b/c it is most recent
        expect(store_page.review_content.first.text).to have_text(review_text_user2)
        expect(store_page.star_ranking.first['star-value']).to have_text("5") 

        expect(store_page.review_content.last.text).to have_text(review_text)
        expect(store_page.star_ranking.last['star-value']).to have_text("1")         
                
        # user3 comments on user2's review
        store_page.tabs_reviews.click
        user3comment = "user3 checking in"
        store_page.new_comment_inputs.first.set user3comment
        store_page.save_new_comment_button.first.click
        wait_for_ajax        
        
        # user 2's review is first, and only user 3 has commented
        expect(store_page.store_review_comments.first).to have_text(user3comment) 

        expect(store_page.store_review_comments[1]).to have_text(user1comment) 
        expect(store_page.store_review_comments.last).to have_text(user2comment)         
    end

	scenario "must be logged on to comment" do
        # login as admin
        page.visit("/")        
        header = HeaderPageComponent.new        
        header.loginlink.click
        
        # login modal
        header.username.set @adminemail
        header.password.set @adminpassword
        header.logininbutton.click

        expect(header.edituserlink.text).to have_text(@adminusername)
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

        store_page.write_review_button.click
        store_page.cancel_write_review_button.click
        store_page.write_review_button.click
        review_text = "I hated this place!"
        store_page.review_text.set review_text
        store_page.save_review_button.click

        #expect success message
        expect(store_page.flash_notice.text).to have_text("Thank you")
        store_page.tabs_reviews.click                    
        expect(store_page.review_content.first.text).to have_text(review_text)
        expect(store_page.star_ranking.first['star-value']).to have_text("1") 

        # users can comment on their own reviews
        store_page.tabs_reviews.click
        user1comment = "selfless promotion"
        store_page.new_comment_inputs.first.set user1comment
        store_page.save_new_comment_button.first.click
        wait_for_ajax
        expect(store_page.store_review_comments.first).to have_text(user1comment) 
        

        # logout
        header.logoutlink.click

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
        store_page.tabs_reviews.click     

        # no comment inputs should be on the page
        num_comment_inputs = store_page.new_comment_inputs.size
        expect(num_comment_inputs).to eq(0)

        num_comment_save_buttons = store_page.save_new_comment_button.size
        expect(num_comment_save_buttons).to eq(0)

        # should have login links in comment section, click and login
        num_log_in_to_comment_links = store_page.log_in_to_comment_links.size
        expect(num_log_in_to_comment_links).to eq(1)
        store_page.log_in_to_comment_links.first.click

        # login as user 2        
        header.username.set @user2email
        header.password.set @user2password
        header.logininbutton.click                
        expect(header.edituserlink.text).to have_text(@user2username)

        # devise should drop you back to the store page, so no need to search for it again
        expect(store_page.name_header.text).to have_text(@store_name)
        store_page.tabs_reviews.click     

        # user2 comments on user1's review
        store_page.tabs_reviews.click
        user2comment = "what a stupid comment!"
        store_page.new_comment_inputs.first.set user2comment
        store_page.save_new_comment_button.first.click
        wait_for_ajax        
        expect(store_page.store_review_comments.first).to have_text(user1comment) 
        expect(store_page.store_review_comments[1]).to have_text(user2comment) 
             
    end
end