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
require 'pages/community_feed_home'
require 'pages/community_feed'
require 'pages/community_post'
require 'pages/admin/manage_flags'

feature "review a store" , :js => true, :search =>true do

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
		
		@item1 =  @store.store_items.create(:name => "og" , :strain =>"indica")
		@item1.cultivation = "indoor"		
		@item1.save
		Sunspot.commit

	end
	
	scenario "login as admin, create a feed, create a post, flag post and delete the flag, logout, nav to post, click username link, get login page" do	
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

		# go to community
		header.community_home_link.click

		community_home_page = CommunityFeedHomePage.new
		
		# add new feed
		community_home_page.add_new_feed_button.click

		new_feed_name = "new stuff"
		community_home_page.new_feed_name_input.set new_feed_name
		community_home_page.save_feed_button.click

		community_home_page.dynamic_feed_links.first.click

		feed_page = CommunityFeedPage.new		
		expect(feed_page.feed_name_span.text).to have_text(new_feed_name)

		# add new post
		feed_page.add_new_post_button.click
		post_title = "my first post"
		post_content = "i don't have much to say"
		feed_page.feed_post_title_input.set post_title
		feed_page.feed_post_content_input.set post_content
		feed_page.save_post_button.click
		
		expect(feed_page.post_titles.first.text).to have_text(post_title)

		feed_page.post_upvote_buttons.size.should == 1
		feed_page.post_upvote_buttons.first.click
		wait_for_ajax
		feed_page.post_flash_notices.size.should == 2
		expect(feed_page.post_flash_notices.first.text).to have_text("your post has been created.")
		expect(feed_page.post_flash_notices.last.text).to have_text("A user can't vote on their own posts")
				
		feed_page.post_flag_links.size.should == 1
		feed_page.post_flag_links.first.click
		feed_page.close_button.click
		feed_page.post_flag_links.first.click
		flag_reason = "this is spam"
		feed_page.flag_reason_input.set flag_reason
		feed_page.save_flag_button.click

		# flags should appear in admin management			
		page.visit("/admin/flags/index")
		page.visit("/admin/flags/index")  # not sure really why, but sometimes the first load doesn't load flags
		admin_manage_flags_page = AdminManageFlagsPage.new
		admin_manage_flags_page.delete_flag_buttons.size.should == 1
		admin_manage_flags_page.delete_flag_buttons.first.click
		admin_manage_flags_page.delete_flag_buttons.size.should == 0
		

        # logout
        header.logoutlink.click

		# go to community
		header.community_home_link.click        
		community_home_page.dynamic_feed_links.first.click

		# click on the username of the first post
		feed_page.post_username_links.first.click

		# must be logged in to see a user profile
		login_page = LoginPage.new		
		login_page.has_username_input?		
		login_page.has_username_password_input?
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword        	
    	login_page.sign_in_button.click		
	end

	scenario "login as admin, create a feed, create a post, flag post, see flag and nav to post, delete post" do	
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

		# go to community
		header.community_home_link.click

		community_home_page = CommunityFeedHomePage.new
		
		# add new feed
		community_home_page.add_new_feed_button.click

		new_feed_name = "new stuff"
		community_home_page.new_feed_name_input.set new_feed_name
		community_home_page.save_feed_button.click

		community_home_page.dynamic_feed_links.first.click

		feed_page = CommunityFeedPage.new		
		expect(feed_page.feed_name_span.text).to have_text(new_feed_name)

		# add new post
		feed_page.add_new_post_button.click
		post_title = "my first post"
		post_content = "i don't have much to say"
		feed_page.feed_post_title_input.set post_title
		feed_page.feed_post_content_input.set post_content
		feed_page.save_post_button.click
		
		expect(feed_page.post_titles.first.text).to have_text(post_title)

		feed_page.post_upvote_buttons.size.should == 1
		feed_page.post_upvote_buttons.first.click
		wait_for_ajax
		feed_page.post_flash_notices.size.should == 2
		expect(feed_page.post_flash_notices.first.text).to have_text("your post has been created.")
		expect(feed_page.post_flash_notices.last.text).to have_text("A user can't vote on their own posts")
		
		feed_page.post_flag_links.size.should == 1
		feed_page.post_flag_links.first.click
		feed_page.close_button.click
		feed_page.post_flag_links.first.click
		flag_reason = "this is spam"
		feed_page.flag_reason_input.set flag_reason
		feed_page.save_flag_button.click

		# flags should appear in admin management			
		page.visit("/admin/flags/index")
		page.visit("/admin/flags/index")  # not sure really why, but sometimes the first load doesn't load flags
		admin_manage_flags_page = AdminManageFlagsPage.new
		
		admin_manage_flags_page.post_links.size.should == 1
		admin_manage_flags_page.post_links.first.click

		# view the flagged post
		post_page =CommunityPostPage.new
		post_page.delete_post_button.click
		wait_for_ajax		
		post_page.delete_post_verify_button.click

		# go to community
		header.community_home_link.click
		community_home_page.dynamic_feed_links.first.click
		feed_page.post_titles.size.should == 0
	end

	scenario "login as admin, create a feed, create a post, log out, flag post, login" do	
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

		# go to community
		header.community_home_link.click

		community_home_page = CommunityFeedHomePage.new
		
		# add new feed
		community_home_page.add_new_feed_button.click

		new_feed_name = "new stuff"
		community_home_page.new_feed_name_input.set new_feed_name
		community_home_page.save_feed_button.click

		community_home_page.dynamic_feed_links.first.click

		feed_page = CommunityFeedPage.new		
		expect(feed_page.feed_name_span.text).to have_text(new_feed_name)

		# add new post
		feed_page.add_new_post_button.click
		post_title = "my first post"
		post_content = "i don't have much to say"
		feed_page.feed_post_title_input.set post_title
		feed_page.feed_post_content_input.set post_content
		feed_page.save_post_button.click
		
		expect(feed_page.post_titles.first.text).to have_text(post_title)

		feed_page.post_upvote_buttons.size.should == 1
		feed_page.post_upvote_buttons.first.click
		wait_for_ajax
		feed_page.post_flash_notices.size.should == 2
		expect(feed_page.post_flash_notices.first.text).to have_text("your post has been created.")
		expect(feed_page.post_flash_notices.last.text).to have_text("A user can't vote on their own posts")
		
		# log out
		header.logoutlink.click

		# go to community
		header.community_home_link.click        

		community_home_page.dynamic_feed_links.first.click

		feed_page.post_flag_links.size.should == 1
		
		# flagging should require login
		feed_page.post_flag_links.first.click

		# login modal
    	header.username.set @adminemail
    	header.password.set @adminpassword
		header.logininbutton.click

		expect(header.edituserlink.text).to have_text(@adminusername)
		
		feed_page.post_flag_links.first.click
		flag_reason = "this is spam"
		feed_page.flag_reason_input.set flag_reason
		feed_page.save_flag_button.click

		# flags should appear in admin management			
		page.visit("/admin/flags/index")
		page.visit("/admin/flags/index")  # not sure really why, but sometimes the first load doesn't load flags
		admin_manage_flags_page = AdminManageFlagsPage.new
		admin_manage_flags_page.delete_flag_buttons.size.should == 1
		admin_manage_flags_page.delete_flag_buttons.first.click
		admin_manage_flags_page.delete_flag_buttons.size.should == 0
		

        # logout
        header.logoutlink.click

		# go to community
		header.community_home_link.click        
		community_home_page = CommunityFeedHomePage.new
		community_home_page.dynamic_feed_links.first.click

		# click on the username of the first post
		feed_page = CommunityFeedPage.new		
		feed_page.post_username_links.first.click

		# must be logged in to see a user profile
		login_page = LoginPage.new		
		login_page.has_username_input?		
		login_page.has_username_password_input?
		login_page.username_input.set @adminemail
    	login_page.username_password_input.set @adminpassword        	
    	login_page.sign_in_button.click		
	end
	

end