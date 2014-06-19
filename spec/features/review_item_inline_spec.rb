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
require 'pages/search_results_items'
require 'pages/itempopup'

feature "item review comments" , :js => true, :search =>true do

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

		@item1_name = "og"
		@item1 =  @store.store_items.create(:name => @item1_name , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save


		Sunspot.commit
	end

	scenario "writing a new review displays inline and is commentable immediately" do
        # login as user 2 
        header = HeaderPageComponent.new    
        header.loginlink.click       
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

        
        expect(itempopup.be_the_first).to have_text("no reviews yet. be the first to review this item!") 

        # user 2 writes his own review        
        itempopup.write_review_button.click
        user2_review_text = "user2_review_text"
        itempopup.review_text_input.set user2_review_text
        itempopup.save_review_button.click
        
    	wait_for_ajax
    	# review should be there
        expect(itempopup.review_content.first.text).to have_text(user2_review_text)
        expect(itempopup.star_ranking.first['star-value']).to have_text("1")   

        # you can comment on your reviews immediately after writing a review
        user2_firstcomment = "user2_firstcomment"
        itempopup.new_comment_inputs.first.set user2_firstcomment
        itempopup.save_new_comment_button.first.click
        wait_for_ajax                
        expect(itempopup.item_review_comments.last).to have_text(user2_firstcomment)  

        page.should have_no_selector(".alert-warning")               
        page.should have_no_selector("#review-item-slide-toggle-button")               

    end

end	