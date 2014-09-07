require 'spec_helper'
require 'capybara/rails'
require 'pages/loginpage'
require 'page_components/header'
require 'pages/registration'
require 'pages/homepage'
require 'pages/admin/stores'
require 'pages/store'
require 'pages/store_items'
require 'pages/search_results_stores'
require 'pages/store_search_preview.rb'
require 'pages/store_claim.rb'

feature "claim store spec" , :js => true, :search =>true do
	
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

	end

	scenario "login as admin, create a store, log out, go to store page, not logged in, claim a store, login, see store claim page" do		
		
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

    	stores_page = AdminStoresPage.new
    	stores_page.load
    	stores_page.has_newstore_button?    	
    	stores_page.newstore_button.click

    	store_name = "My New Store"
    	stores_page.modal_store_name_input.set store_name
    	stores_page.modal_save_button.click

        # modify store's plan ID
        @store = Store.find_by_name(store_name)
        @store.plan_id = 5
        @store.save
    
        # reload the page after setting plan id
        page.visit(store_path(@store))

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
    	new_email = @adminemail
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


		# log out
		header.logoutlink.click

		# search for it		
		header = HeaderPageComponent.new  
        header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	# search_results_page = SearchResultsStoresPageComponent.new    	
    	# expect(search_results_page.firstSearchResult_store_name.text).to have_text(store_name)
        search_results_page = SearchResultsStoresPageComponent.new      
                
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [store_name]


    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	
    	store_page = StorePage.new
    	store_page.has_name_header?
		expect(store_page.name_header.text).to have_text(store_name)    
		store_page.claim_store_button.click

		# login
		login_prompt = "You must sign in as the user who's email appears on that store's page inorder to claim this store"	
		expect(page).to have_text(login_prompt)    
		login_page.has_username_input?
		login_page.has_username_password_input?

		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	store_claim_page = StoreClaimPage.new
    	expect(store_claim_page.name_header.text).to have_text(store_name)
    	expect(page).to have_text("Signed in successfully.")   

    	# cancel and come back
    	store_claim_page.cancel_claim_button.click
    	store_page.claim_store_button.click    	
    	expect(page).not_to have_content("Signed in successfully.")

    	# claim
    	store_claim_page.claim_store_button.click
		expect(page).to have_text("You have successfully claimed this store.")       	
		
		expect(store_page.edit_links_tip.text).to have_text("edit links are now available for you")
        store_has_claim_button = store_page.has_claim_store_button?        
        assert_equal( false, store_has_claim_button, 'Store should not have a claim button after it is claimed')

        # logout
        header.logoutlink.click

        # write a review as user 2                
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

        # search_results_page = SearchResultsStoresPageComponent.new        
        # expect(search_results_page.firstSearchResult_store_name.text).to have_text(store_name)
        search_results_page = SearchResultsStoresPageComponent.new      
                
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [store_name]


        # click and view preview
        search_results_page.search_results_store_names.first.click
        
        store_page = StorePage.new
        store_page.has_name_header?
        expect(store_page.name_header.text).to have_text(store_name)    

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

        # login as store owner (admin)
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
        search_results_page.search_results_store_names.map {|name| name.text}.should == [store_name]

        # click and view preview
        search_results_page.search_results_store_names.first.click
        store_page = StorePage.new
        expect(store_page.name_header.text).to have_text(@store_name)

        # store owners can comment on reviews
        store_page.tabs_reviews.click
        storeownercomment = "sorry about that!"
        store_page.new_comment_inputs.first.set storeownercomment
        store_page.save_new_comment_button.first.click
        wait_for_ajax
            
        expect(store_page.store_review_comments.first).to have_text(storeownercomment) 

        # is it badged?  highlighted?        
        expect(store_page.owner_badges.size).to eq(1)
        expect(store_page.owner_comments.first.text).to have_text(storeownercomment) 

        # the above tests ajax response.  Now refresh the page and make sure that the badges + css highlights are still there
        page.visit(current_path)
        expect(store_page.name_header.text).to have_text(@store_name)
        store_page.tabs_reviews.click
        expect(store_page.store_review_comments.first).to have_text(storeownercomment) 

        # is it badged?  highlighted?        
        expect(store_page.owner_badges.size).to eq(1)
        expect(store_page.owner_comments.first.text).to have_text(storeownercomment) 

  	end

	scenario "login as admin, create a store, DONT log out, go to store page, claim a store, don't see login, see store claim page" do		
		
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
    	new_email = @adminemail
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

		store_page.claim_store_button.click

    	store_claim_page = StoreClaimPage.new
    	expect(store_claim_page.name_header.text).to have_text(store_name)
    	
  	end

    scenario "try and hit claim button on a store that doesn't match your email" do      
        
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
        new_email = "joe@gmail.com"
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

        store_page.claim_store_button.click

        store_claim_page = StoreClaimPage.new
        expect(store_claim_page.name_header.text).to have_text(store_name)
        expect(page).to have_text("does not match the email listed")
        store_claim_page.has_logout_and_try_again?
        store_claim_page.logout_and_try_again.click
    end
end  	