require 'test_helper'
 
# Tests our integraiton with Rollify at a model level.  Does not test at a view level.

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

	test "removing a scoped role doesn't affect other store instances" do
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

		user.add_role :storeowner, store_other # sets a role for a resource instance
		result_other_store = user.has_role? :storeowner, store_other
		
		#binding.pry
		assert_equal( true, result_other_store, 'User should have storeowner role assigned but does not')

		# delete role from first store
		user.remove_role :storeowner, store
		result_after_remove = user.has_role? :storeowner, store
		assert_equal( false, result_after_remove, 'User should NOT have storeowner role assigned AFTER removal but does')

		# other store should be the same		
		other_result_after_remove = user.has_role? :storeowner, store_other
		assert_equal( true, other_result_after_remove, 'User should have storeowner role assigned AFTER removal but does not')

		# add it back just for yucks
		user.add_role :storeowner, store # sets a role for a resource instance
		result_after_adding_it_back = user.has_role? :storeowner, store
		assert_equal( true, result_after_adding_it_back, 'User should have storeowner role assigned but does not')
	end	

	test "add/remove role via service" do
		service = Simpleweed::Security::Roleservice.new

		user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save

		# create Stores
		store = Store.new
		store.name = "ABC Weed"
		store.save
		store_other = Store.new
		store_other.name = "CostCo Weed"
		store_other.save

		#user.add_role :storeowner, store # sets a role for a resource instance
		service.addStoreOwnerRoleToStore(user, store)
		result = user.has_role? :storeowner, store
		assert_equal( true, result, 'User should have storeowner role assigned but does not')
		storeOwnersForStore = service.findStoreOwnerForStore(store)
		assert_equal( 1, storeOwnersForStore.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStore.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isStoreOwner(user,store), 'This user should be a store owner')		

		#user.add_role :storeowner, store_other # sets a role for a resource instance
		service.addStoreOwnerRoleToStore(user, store_other)
		result_other_store = user.has_role? :storeowner, store_other
				
		assert_equal( true, result_other_store, 'User should have storeowner role assigned but does not')
		storeOwnersForStore2 = service.findStoreOwnerForStore(store_other)
		assert_equal( 1, storeOwnersForStore2.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStore2.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isStoreOwner(user,store_other), 'This user should be a store owner')		

		# delete role from first store
		#user.remove_role :storeowner, store
		service.removeStoreOwnerRoleFromUserAndStore(user, store)
		result_after_remove = user.has_role? :storeowner, store
		assert_equal( false, result_after_remove, 'User should NOT have storeowner role assigned AFTER removal but does')
		storeOwnersForStoreAfterRemoval = service.findStoreOwnerForStore(store)
		assert_equal( 0, storeOwnersForStoreAfterRemoval.size, 'There should be 0 store owner for this store')		
		assert_equal( false, storeOwnersForStoreAfterRemoval.include?(user), 'There should be 0 store owner for this store')
		assert_equal( false, service.isStoreOwner(user,store), 'This user should NOT be a store owner')		

		# other store should be the same		
		other_result_after_remove = user.has_role? :storeowner, store_other
		assert_equal( true, other_result_after_remove, 'User should have storeowner role assigned AFTER removal but does not')
		storeOwnersForStoreOtherAfterRemoval = service.findStoreOwnerForStore(store_other)
		assert_equal( 1, storeOwnersForStoreOtherAfterRemoval.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStoreOtherAfterRemoval.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isStoreOwner(user,store_other), 'This user should be a store owner')		

		# add it back just for yucks
		#user.add_role :storeowner, store # sets a role for a resource instance
		service.addStoreOwnerRoleToStore(user, store)
		result_after_adding_it_back = user.has_role? :storeowner, store
		assert_equal( true, result_after_adding_it_back, 'User should have storeowner role assigned but does not')
		storeOwnersForStoreAfterReadd = service.findStoreOwnerForStore(store)
		assert_equal( 1, storeOwnersForStoreAfterReadd.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStoreAfterReadd.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isStoreOwner(user,store), 'This user should be a store owner')		

	end
end