require 'test_helper'
 
class Roles < ActiveSupport::TestCase

	test "add basic admin role via rollify" do
		user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		assert_equal( true, result, 'User should have admin role assigned but does not')
	end	

	test "add scoped role to a single store" do
		user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save

		# create Stores
		store = Store.new
		store.name = "ABC Weed"
		store.save
		store_other = Store.new
		store_other.name = "CostCo Weed"
		store_other.save

		user.add_role :storeowner, store # sets a role for a resource instance
		result = user.has_role? :storeowner, store
		assert_equal( true, result, 'User should have storeowner role assigned but does not')

		result_other_store = user.has_role? :storeowner, store_other
		
		#binding.pry
		assert_equal( false, result_other_store, 'User should NOT have storeowner role assigned but does')

	end	



end