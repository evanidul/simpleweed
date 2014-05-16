module Simpleweed
	module Security
		class Roleservice
			
			# a storeowner is both a storeowner and also granted the storemanager role.  Storeowner's can edit store email addresses
			# (thereby allowing claims and such).  Store managers can manage most other things (menus, store hours, etc).

	  		# sets a role for a resource instance
	  		# replaces user.add_role :storeowner, store 
	  		# don't want that sort of code in the codebase as it may lead to holes if I mistype and grant global roles
	  		def addStoreOwnerRoleToStore(user, store)
	  			user.add_role :storeowner, store
	  			addStoreManagerRoleToStore(user, store)
	  		end 

	  		def removeStoreOwnerRoleFromUserAndStore(user, store)
	  			user.remove_role :storeowner, store
	  			removeStoreManagerRoleFromUserAndStore(user, store)
	  		end

	  		def addStoreManagerRoleToStore(user, store)
	  			user.add_role :storemanager, store
	  		end 

	  		def removeStoreManagerRoleFromUserAndStore(user, store)
	  			user.remove_role :storemanager, store
	  		end


	  		def findStoreOwnerForStore(store) 
	  			return User.with_role(:storeowner, store)
	  		end

	  		def findStoreManagersForStore(store)
	  			return User.with_role(:storemanager, store)
	  		end

	  		def isStoreOwner(user, store)
	  			store_owners = findStoreOwnerForStore(store)
	  			return store_owners.include?(user)
	  		end 

	  		def isStoreManager(user, store) 
	  			store_managers = findStoreManagersForStore(store)
	  			return store_managers.include?(user)
	  		end

		end #class
	end
end