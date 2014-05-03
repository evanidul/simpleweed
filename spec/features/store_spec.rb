require 'spec_helper'
require 'capybara/rails'

feature "store page" , :js => true do
	before :each do
	  	@basicauthname = "ddadmin"
	  	@basicauthpassword = "idontreallysmoke" 
	  	page.visit("http://#{@basicauthname}:#{@basicauthpassword}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/")
	end

	scenario "" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		
		page.visit("/")
		expect(page).to have_content("Hello"), "or else!"          
  	end

	scenario "" do
		# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
		# page.visit("http://#{@basicauthname}:#{@basicauthpassword}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/")
		page.visit("/stores/26888")
		expect(page).to have_content("024"), "or else!"          
  	end



end
