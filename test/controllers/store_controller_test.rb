require 'test_helper'

class StoresControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
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
		
		user = 'ddadmin'
    	pw = 'idontreallysmoke'
    	request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
	end

  	test "show store page" do
  		get :show, id: @store.id
  		assert_response :success
  	end 

  	test "change store description" do
  		put :update_description, store: {id: @store.id, description: "new description" }
  		assert_response :success
  	end

end
