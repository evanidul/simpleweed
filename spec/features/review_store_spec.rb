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
end