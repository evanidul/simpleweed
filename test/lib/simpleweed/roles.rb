require 'test_helper'
 
# Tests our integraiton with Rollify at a model level.  Does not test at a view level.

class Roles < ActiveSupport::TestCase

	test "add basic admin role via rollify" do
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		assert_equal( true, result, 'User should have admin role assigned but does not')
	end	

	test "admins can manage posts" do
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		assert_equal( true, result, 'User should have admin role assigned but does not')

		roleservice = Simpleweed::Security::Roleservice.new
		assert_equal(true, roleservice.canManagePost(user) , 'admins should be able to manage posts')
	end

	test "admins can add new community feeds" do
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		assert_equal( true, result, 'User should have admin role assigned but does not')

		roleservice = Simpleweed::Security::Roleservice.new
		assert_equal(true, roleservice.canAddCommunityFeed(user) , 'admins should be able to add new community feeds')
	end

	test "normal users cannot add community feeds nor manage posts" do
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save

		result = user.has_role? :admin

		assert_equal( false , result, 'User should NOT have admin role assigned')

		roleservice = Simpleweed::Security::Roleservice.new
		assert_equal(false, roleservice.canAddCommunityFeed(user) , 'normal users should not be able to add community feeds')

		assert_equal(false, roleservice.canManagePost(user) , 'normal users should not be able to delete posts')

	end

	test "add scoped role to a single store" do
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
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
		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
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

	test "add/remove store owner/store manager via service" do
		service = Simpleweed::Security::Roleservice.new

		user = User.new(:username => 'user1', :email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save

		# create Stores
		store = Store.new
		store.name = "ABC Weed"
		store.save
		store_other = Store.new
		store_other.name = "CostCo Weed"
		store_other.save

		assert_equal(false, service.isStoreOwner(user) ,"user has not been assigned store owner role yet")
		assert_equal(false, service.isStoreManager(user) , "user has not been assigned store manager role yet")

		#user.add_role :storeowner, store # sets a role for a resource instance
		service.addStoreOwnerRoleToStore(user, store)
		result = user.has_role? :storeowner, store
		assert_equal(true, result, 'User should have storeowner role assigned but does not')
		assert_equal(true, service.isStoreOwner(user) ,"user has been assigned store owner")		
		assert_equal(true, service.isStoreManager(user) , "users that are store owners are also store managers")

		storeOwnersForStore = service.findStoreOwnerForStore(store)
		assert_equal( 1, storeOwnersForStore.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStore.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isUserStoreOwnerOf(user,store), 'This user should be a store owner')		
		assert_equal( 1, service.findStoreManagersForStore(store).size, 'There should be 1 store manager for this store')		
		assert_equal( true, service.isUserStoreManagerOf(user,store), 'This user should be a store manager')		

		#user.add_role :storeowner, store_other # sets a role for a resource instance
		service.addStoreOwnerRoleToStore(user, store_other)
		result_other_store = user.has_role? :storeowner, store_other
	
		assert_equal(true, service.isStoreOwner(user) ,"user has been assigned store owner")		
		assert_equal(true, service.isStoreManager(user) , "users that are store owners are also store managers")
				
		assert_equal( true, result_other_store, 'User should have storeowner role assigned but does not')
		storeOwnersForStore2 = service.findStoreOwnerForStore(store_other)
		assert_equal( 1, storeOwnersForStore2.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStore2.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isUserStoreOwnerOf(user,store_other), 'This user should be a store owner')		
		assert_equal( 1, service.findStoreManagersForStore(store_other).size, 'There should be 1 store manager for this store')		
		assert_equal( true, service.isUserStoreManagerOf(user,store_other), 'This user should be a store manager')		

		# delete role from first store
		#user.remove_role :storeowner, store
		assert_equal(true, service.isStoreOwner(user) ,"user has been assigned store owner")		
		assert_equal(true, service.isStoreManager(user) , "users that are store owners are also store managers")

		service.removeStoreOwnerRoleFromUserAndStore(user, store)
		result_after_remove = user.has_role? :storeowner, store
		assert_equal( false, result_after_remove, 'User should NOT have storeowner role assigned AFTER removal but does')
		storeOwnersForStoreAfterRemoval = service.findStoreOwnerForStore(store)
		assert_equal( 0, storeOwnersForStoreAfterRemoval.size, 'There should be 0 store owner for this store')		
		assert_equal( false, storeOwnersForStoreAfterRemoval.include?(user), 'There should be 0 store owner for this store')
		assert_equal( false, service.isUserStoreOwnerOf(user,store), 'This user should NOT be a store owner')		
		assert_equal( 0, service.findStoreManagersForStore(store).size, 'There should be 0 store manager for this store')		
		assert_equal( false, service.isUserStoreManagerOf(user,store), 'This user should not be a store manager')		

		# other store should be the same		
		other_result_after_remove = user.has_role? :storeowner, store_other
		assert_equal( true, other_result_after_remove, 'User should have storeowner role assigned AFTER removal but does not')
		storeOwnersForStoreOtherAfterRemoval = service.findStoreOwnerForStore(store_other)
		assert_equal( 1, storeOwnersForStoreOtherAfterRemoval.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStoreOtherAfterRemoval.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isUserStoreOwnerOf(user,store_other), 'This user should be a store owner')		
		assert_equal( 1, service.findStoreManagersForStore(store_other).size, 'There should be 1 store manager for this store')		
		assert_equal( true, service.isUserStoreManagerOf(user,store_other), 'This user should be a store manager')		

		# add it back just for yucks
		#user.add_role :storeowner, store # sets a role for a resource instance
		assert_equal(true, service.isStoreOwner(user) ,"user has been assigned store owner")		
		assert_equal(true, service.isStoreManager(user) , "users that are store owners are also store managers")
		service.addStoreOwnerRoleToStore(user, store)
		result_after_adding_it_back = user.has_role? :storeowner, store
		assert_equal( true, result_after_adding_it_back, 'User should have storeowner role assigned but does not')
		storeOwnersForStoreAfterReadd = service.findStoreOwnerForStore(store)
		assert_equal( 1, storeOwnersForStoreAfterReadd.size, 'There should be 1 store owner for this store')		
		assert_equal( true, storeOwnersForStoreAfterReadd.include?(user), 'There should be 1 store owner for this store')
		assert_equal( true, service.isUserStoreOwnerOf(user,store), 'This user should be a store owner')	
		assert_equal( 1, service.findStoreManagersForStore(store).size, 'There should be 1 store manager for this store')			
		assert_equal( true, service.isUserStoreManagerOf(user,store), 'This user should be a store manager')		
		
	end
end