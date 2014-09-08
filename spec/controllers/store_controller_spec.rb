require 'spec_helper'

describe StoresController do

	describe 'GET #show' do
		it "shows a store page" do
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

			get :show, id: @store.id

			expect(response).to render_template :show
		end

	end

end
