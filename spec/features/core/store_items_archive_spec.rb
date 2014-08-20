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
require 'pages/store_items_archive_prompt.rb'
require 'pages/store_archived_items.rb'

feature "store item archive tests" , :js => true, :search =>true do

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

	scenario "create a store, add some items, archive item, unarchive item" do
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	page.visit(store_path(@store))
    	store_page = StorePage.new

    	page.visit(store_store_items_path(@store))
    	items_page = StoreItemsPage.new		
		expect(items_page.store_name.text).to have_text(@store_name)
		items_page.add_store_item_button.click

		# add new item
		item_name = "Weedy"
		items_page.store_item_name.set item_name
		items_page.store_item_strain.select 'sativa'
		items_page.store_item_maincategory.select 'flower'
		items_page.store_item_subcategory.select 'bud'

		items_page.save_store_item_button.click

		# back to items index
		row_links = items_page.row_links

	    	#items_page.searchresults[index].click
	    	#items_page.searchresults.first.click # most recently added will be on top?
	    	 
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}

	    items_page.archive_item_button.click
		
		store_items_archive_prompt_page = StoreItemsArchivePromptPage.new
		store_items_archive_prompt_page.archive_button.click

		expect(page).to have_text('has been archived')
		
		items_page.archived_items_button.click
		
		archived_items_page = StoreArchivedItemsPage.new

		#archived_items_row_links = archived_items_page.row_links
 
    	archived_items_page.searchresults.each {|item_link| 
    		
    		if item_link.text.include? item_name
    			item_link.click
    			break
    		end

    	}

    	archived_items_page.unarchive_button.click

		expect(page).to have_text('has been unarchived')

		items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}
	end	    	

end	