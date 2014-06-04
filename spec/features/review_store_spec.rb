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

		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit
	end

	
	scenario "no reviews for store, should see prompt to be first" do	
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
		
		# tooltip there?    	
    	expect(store_page.first_write_review_tooltip.text).to have_text("Be the first")
	end

	scenario "review a star with default 1 star" do
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
	end

	scenario "review , choose 1 star" do
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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.onestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("1")    	
	end

	scenario "review , choose 2 star" do
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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.twostar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("2")    	
	end

	scenario "review , choose 3 star" do
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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.threestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("3")    	
	end

	scenario "review , choose 4 star" do
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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.fourstar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("4")    	
	end

	scenario "review , choose 5 star" do
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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.fivestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("5")    	
	end

	scenario "logged out, try to review, fill out login modal, write review" do
		
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

    	# EXPECT LOGIN PROMPT
    	# login as admin
		header = HeaderPageComponent.new
    	# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)		
		expect(store_page.flash_notice.text).to have_text("Signed in successfully")

		# write a review
		store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.fivestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("5")    	
	end

	scenario "logged out, try to review, fill out login modal BADLY, see login page, login correctly, write review" do
		
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

    	# EXPECT LOGIN PROMPT
    	# login as admin
		header = HeaderPageComponent.new
    	# login modal
    	header.username.set @adminemail
    	header.password.set "some bullshit"
		header.logininbutton.click

		# see full login page and login
		login_page = LoginPage.new
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	# on store page...
		expect(header.edituserlink.text).to have_text(@adminusername)		
		expect(store_page.flash_notice.text).to have_text("Signed in successfully")

		# write a review
		store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.fivestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("5")    	
	end
	
	scenario "logged out, try to review, see login modal, hit register link, see reg page, register, confirm email" do
		
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

    	# EXPECT LOGIN PROMPT
    	# login as admin
		header = HeaderPageComponent.new
    	# login modal
    	header.register_link_onlogin_modal.click

		# see registration page
		username = "bob123"
  		email = "bob@gmail.com"
  		password = "password"
  		
  		# register page
  		registrationPage = RegistrationPageComponent.new
  		registrationPage.user_name.set username
      	registrationPage.user_email.set email
  		registrationPage.user_password.set password
  		registrationPage.user_password_confirmation.set password
  		registrationPage.create_user_account_button.click

  		expect(page).to have_text("A message with a confirmation link has been sent to your email address"), "or else!"  

		# plugin some email verification gem and verify account creation
		# http://stackoverflow.com/questions/8886748/testing-account-confirmation-with-rails-rspec-capybara-devise	
		emailproxy = open_email(email)
		emailproxy.should deliver_to(email)
		
		# click_link "Confirm my account"
		click_first_link_in_email		
		sleep 2

		# see full login page and login
		login_page = LoginPage.new
		login_page.username_input.set username
    	login_page.username_password_input.set password
    	login_page.sign_in_button.click

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
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.fivestar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("5")    

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
        header.search_button.click

    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	expect(store_page.name_header.text).to have_text(@store_name)

    	store_page.write_review_button.click
		review_text = "I hated this place!"
    	store_page.review_text.set review_text
    	store_page.twostar_button.click
    	store_page.save_review_button.click

    	#expect success message
    	expect(store_page.flash_notice.text).to have_text("Thank you")
    	store_page.tabs_reviews.click
    	    	    
    	expect(store_page.review_content.first.text).to have_text(review_text)

		expect(store_page.star_ranking.first['star-value']).to have_text("2") 

		store_page.write_review_button_blocked.click
		expect(store_page.write_review_button_blocked_tooltip).to have_text("you've already reviewed this store") 
			

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

        # try and review the store as the owner, see tooltip saying you can't
        store_page.write_review_button_blocked.click        
		expect(store_page.write_review_button_blocked_tooltip).to have_text("store managers cannot review their own stores") 
  	end

  	scenario "reviewing one store blocks you from reviewing that store, but should not prevent you from reviewing a second store" do

  	end
end