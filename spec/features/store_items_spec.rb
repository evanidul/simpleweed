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

	# saving a store and loading that store in store item menu page can lead to a race condition.  since store.save returns before
	# the db save/commit happens, it's possible for selenium to find(store_id) before the save is processed.  Therefore, we make 
	# this test a little lazy by reloading some other pages first.
	scenario "create a store, add some items" do		
		
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
        header = HeaderPageComponent.new	
		header.search_input.set "7110 Rock Valley Court, San Diego, CA"
        header.search_button.click

    	# search_results_page = SearchResultsStoresPageComponent.new    	
    	# expect(search_results_page.firstSearchResult_store_name.text).to have_text(@store_name)
    	search_results_page = SearchResultsStoresPageComponent.new    	
    	        
        search_results_page.search_results_store_names.size.should == 1
        search_results_page.search_results_store_names.map {|name| name.text}.should == [@store_name]

    	# click and view preview
    	search_results_page.search_results_store_names.first.click
    	store_page = StorePage.new
    	store_page.has_name_header?

		# edit menu		
		store_page.edit_store_items.click

		items_page = StoreItemsPage.new		
		expect(items_page.store_name.text).to have_text(@store_name)
		items_page.add_store_item_button.click

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
    	row_links = items_page.row_links

	    	#items_page.searchresults[index].click
	    	#items_page.searchresults.first.click # most recently added will be on top?
	    	 
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}

		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
    	expect(items_page.store_item_description.value).to have_text(item_description)
		expect(items_page.thc.value).to have_text(item_thc)
		expect(items_page.cbd.value).to have_text("5.2") # trailing 0 gets dropped
		expect(items_page.cbn.value).to have_text(item_cbn)
		expect(items_page.store_item_costhalfgram.value).to have_text(item_costhalfgram)
		expect(items_page.store_item_costonegram.value).to have_text(item_costgram)
		expect(items_page.store_item_costeighthoz.value).to have_text(item_costeighth)
		expect(items_page.store_item_costquarteroz.value).to have_text(item_costquarter)
		expect(items_page.store_item_costhalfoz.value).to have_text(item_costhalfoz)
		expect(items_page.store_item_costoneoz.value).to have_text(item_costoz)
		expect(items_page.store_item_costperunit.value).to have_text(item_perunit)	

		expect(items_page.store_item_strain.value).to have_text('indica')	
		expect(items_page.store_item_maincategory.value).to have_text('flower')
		expect(items_page.store_item_subcategory.value).to have_text('bud')		
			
		
		# change values	
		item_nameUP = "weedy 2 up"
		item_descriptionUP = "It's so weedy updated."
		item_thcUP = "2"
		item_cbdUP = "5"
		item_cbnUP = "0.5"
		item_costhalfgramUP = "12"
		item_costgramUP = "22"
		item_costeighthUP = "52"
		item_costquarterUP = "102"
		item_costhalfozUP = "202"
		item_costozUP = "402"
		item_costperunitUP = "20"
		
		items_page.store_item_name.set item_nameUP
		items_page.store_item_description.set item_descriptionUP
		items_page.thc.set item_thcUP
		items_page.cbd.set item_cbdUP		
		items_page.cbn.set item_cbnUP
		items_page.store_item_costhalfgram.set item_costhalfgramUP
		items_page.store_item_costonegram.set item_costgramUP
		items_page.store_item_costeighthoz.set item_costeighthUP
		items_page.store_item_costquarteroz.set item_costquarterUP
		items_page.store_item_costhalfoz.set item_costhalfozUP
		items_page.store_item_costoneoz.set item_costozUP
		items_page.store_item_costperunit.set item_costperunitUP
		

		items_page.save_store_item_button.click

		# verify updated values
		# back to item list
    	row_links = items_page.row_links

	    	#items_page.searchresults[index].click
	    	#items_page.searchresults.first.click # most recently added will be on top?
	    	 
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_nameUP
	    			item_link.click
	    			break
	    		end

	    	}

		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_nameUP)
    	expect(items_page.store_item_description.value).to have_text(item_descriptionUP)
		expect(items_page.thc.value).to have_text(item_thcUP)
		expect(items_page.cbd.value).to have_text(item_cbdUP) 
		expect(items_page.cbn.value).to have_text(item_cbnUP)
		expect(items_page.store_item_costhalfgram.value).to have_text(item_costhalfgramUP)
		expect(items_page.store_item_costonegram.value).to have_text(item_costgramUP)
		expect(items_page.store_item_costeighthoz.value).to have_text(item_costeighthUP)
		expect(items_page.store_item_costquarteroz.value).to have_text(item_costquarterUP)
		expect(items_page.store_item_costhalfoz.value).to have_text(item_costhalfozUP)
		expect(items_page.store_item_costoneoz.value).to have_text(item_costozUP)
		expect(items_page.store_item_costperunit.value).to have_text(item_costperunitUP)

  	end

	scenario "create a store, add some items: categories" do
		page.visit("/users/sign_in")
		login_page = LoginPage.new
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword
    	login_page.sign_in_button.click

    	page.visit(store_path(@store))
    	store_page = StorePage.new

    	categoryset =[
  				['bud','flower'],  
  				['shake','flower'],
  				['trim','flower'],

  				['wax','concentrate'],
  				['hash','concentrate'],
  				['budder/earwar/honeycomb/supermelt', 'concentrate'],
  				['bubble hash/full melt/ice wax','concentrate'],
  				['ISO hash','concentrate'],
  				['kief/dry sieve','concentrate'],
  				['shatter/amberglass','concentrate'],
  				['scissor/finger hash','concentrate'],
  				['oil/cartridge','concentrate'],

  				['baked','edible'],
  				['candy/chocolate', 'edible'],
  				['cooking', 'edible'],
  				['drink','edible'],
  				['frozen','edible'],
  				['other','edible'],

  				['blunt','pre-roll'],
  				['joint','pre-roll'],

  				['clones','other'],
  				['seeds','other'],
  				['oral','other'],
  				['topical','other'],

  				['bong/pipe','accessory'],
  				['bong/pipe accessories','accessory'],
  				['book/magazine','accessory'],
  				['butane/lighter','accessory'],
  				['cleaning','accessory'],
  				['clothes','accessory'],
  				['grinder','accessory'],
  				['other','accessory'],
  				['paper/wrap','accessory'],
  				['storage','accessory'],
  				['vape','accessory'],
  				['vape accessories','accessory']
  			]

  		#categoryset.each do |categorypair|
  		categoryset.each_with_index {|val, index| 
  			#puts "#{val} => #{index}" 
			# edit menu		
			#store_page.edit_store_items.click
			page.visit(store_store_items_path(@store))

			items_page = StoreItemsPage.new		
			expect(items_page.store_name.text).to have_text(@store_name)
			items_page.add_store_item_button.click

			# add new item
			item_name = val[1] + ":" + val[0]
			items_page.store_item_name.set item_name
			items_page.store_item_strain.select 'sativa'
			items_page.store_item_maincategory.select val[1]
			items_page.store_item_subcategory.select val[0]

			items_page.save_store_item_button.click

			# back to item list			
	    	#expect(items_page.firstSearchResult_item_name.text).to have_text(item_name)
	    	row_links = items_page.row_links

	    	#items_page.searchresults[index].click
	    	#items_page.searchresults.first.click # most recently added will be on top?
	    	 
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}

	    		
	    	
	    	# items_page.firstSearchResult_item_name.click

			# verify values    	
	    	expect(items_page.store_item_name.value).to have_text(item_name)
			expect(items_page.store_item_strain.value).to have_text('sativa')	
			expect(items_page.store_item_maincategory.value).to have_text(val[1])
			expect(items_page.store_item_subcategory.value).to have_text(val[0])	

		}
		#end # categoryset.each
	end

	scenario "create a store, add some items: misc attributes, popular strains" do
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

		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_privatereserve.should_not be_checked
		items_page.store_item_topshelf.should_not be_checked
		items_page.store_item_dogo.should_not be_checked
		items_page.store_item_supersize.should_not be_checked
		items_page.store_item_glutenfree.should_not be_checked
		items_page.store_item_sugarfree.should_not be_checked
		items_page.store_item_organic.should_not be_checked

		items_page.og.should_not be_checked
		items_page.kush.should_not be_checked
		items_page.haze.should_not be_checked

		# update values
		items_page.store_item_privatereserve.set true
		items_page.store_item_topshelf.set true
		items_page.store_item_dogo.set true
		items_page.store_item_supersize.set true
		items_page.store_item_glutenfree.set true
		items_page.store_item_sugarfree.set true
		items_page.store_item_organic.set true

		items_page.og.set true
		items_page.kush.set true
		items_page.haze.set true
		
		items_page.save_store_item_button.click

		# back to items index
		row_links = items_page.row_links
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}

		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		
		items_page.store_item_privatereserve.should be_checked
		items_page.store_item_topshelf.should be_checked
		items_page.store_item_dogo.should be_checked
		items_page.store_item_supersize.should be_checked
		items_page.store_item_glutenfree.should be_checked
		items_page.store_item_sugarfree.should be_checked
		items_page.store_item_organic.should be_checked

		items_page.og.should be_checked
		items_page.kush.should be_checked
		items_page.haze.should be_checked

		# update values, set all to false
		items_page.store_item_privatereserve.set false
		items_page.store_item_topshelf.set false
		items_page.store_item_dogo.set false
		items_page.store_item_supersize.set false
		items_page.store_item_glutenfree.set false
		items_page.store_item_sugarfree.set false
		items_page.store_item_organic.set false

		items_page.og.set false
		items_page.kush.set false
		items_page.haze.set false

		items_page.save_store_item_button.click

		# back to items index
		row_links = items_page.row_links
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}
		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_privatereserve.should_not be_checked
		items_page.store_item_topshelf.should_not be_checked
		items_page.store_item_dogo.should_not be_checked
		items_page.store_item_supersize.should_not be_checked
		items_page.store_item_glutenfree.should_not be_checked
		items_page.store_item_sugarfree.should_not be_checked
		items_page.store_item_organic.should_not be_checked

		items_page.og.should_not be_checked
		items_page.kush.should_not be_checked
		items_page.haze.should_not be_checked

    end

	scenario "create a store, add some items: cultivation" do
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
		item_name = "weedy"
		items_page.store_item_name.set item_name
		items_page.store_item_strain.select 'sativa'
		items_page.store_item_maincategory.select "flower"
		items_page.store_item_subcategory.select "bud"
		items_page.store_item_cultivation_none.set true

		items_page.save_store_item_button.click

		# back to item list
		row_links = items_page.row_links	    	
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}
		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_cultivation_none.should be_checked
		items_page.store_item_cultivation_indoor.should_not be_checked
		items_page.store_item_cultivation_outdoor.should_not be_checked
		items_page.store_item_cultivation_hydroponic.should_not be_checked
		items_page.store_item_cultivation_greenhouse.should_not be_checked
		

    	# update
		items_page.store_item_cultivation_indoor.set true
		items_page.save_store_item_button.click

		# back to item list
		row_links = items_page.row_links	    	
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}
		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_cultivation_none.should_not be_checked
		items_page.store_item_cultivation_indoor.should be_checked
		items_page.store_item_cultivation_outdoor.should_not be_checked
		items_page.store_item_cultivation_hydroponic.should_not be_checked
		items_page.store_item_cultivation_greenhouse.should_not be_checked
		

		# update
		items_page.store_item_cultivation_outdoor.set true
		items_page.save_store_item_button.click

		# back to item list
		row_links = items_page.row_links	    	
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}

		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_cultivation_none.should_not be_checked
		items_page.store_item_cultivation_indoor.should_not be_checked
		items_page.store_item_cultivation_outdoor.should be_checked
		items_page.store_item_cultivation_hydroponic.should_not be_checked
		items_page.store_item_cultivation_greenhouse.should_not be_checked
		

		# update
		items_page.store_item_cultivation_hydroponic.set true
		items_page.save_store_item_button.click

		# back to item list
		row_links = items_page.row_links	    	
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}	
		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_cultivation_none.should_not be_checked
		items_page.store_item_cultivation_indoor.should_not be_checked
		items_page.store_item_cultivation_outdoor.should_not be_checked
		items_page.store_item_cultivation_hydroponic.should be_checked
		items_page.store_item_cultivation_greenhouse.should_not be_checked
		
	
		# update
		items_page.store_item_cultivation_greenhouse.set true
		items_page.save_store_item_button.click

		# back to item list
		row_links = items_page.row_links	    	
	    	items_page.searchresults.each {|item_link| 
	    		
	    		if item_link.text.include? item_name
	    			item_link.click
	    			break
	    		end

	    	}	
		# verify values    	
    	expect(items_page.store_item_name.value).to have_text(item_name)
		expect(items_page.store_item_strain.value).to have_text('sativa')	
		items_page.store_item_cultivation_none.should_not be_checked
		items_page.store_item_cultivation_indoor.should_not be_checked
		items_page.store_item_cultivation_outdoor.should_not be_checked
		items_page.store_item_cultivation_hydroponic.should_not be_checked
		items_page.store_item_cultivation_greenhouse.should be_checked
		
		
    end
end