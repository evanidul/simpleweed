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

	  		# dvu: returns true if the user is the store owner for the GIVEN store, but false if given another store. 
	  		# Use isStoreOwner(user) if you just want to check if the user owns ANY stores.
	  		def isUserStoreOwnerOf(user, store)
	  			if user.nil? || store.nil?
	  				return false
	  			else
	  				return user.has_role? :storeowner, store
	  			end
	  		end 

	  		# dvu: is this user a store owner for ANY stores?
	  		def isStoreOwner(user)
	  			if user.nil?
	  				return false
	  			else
	  				# returns all stores that this user is a storeowner of
	  				stores = Store.with_role(:storeowner, user)
	  				if stores.empty? #returns empty array, not nil
	  					return false
	  				else 
	  					return true
	  				end
	  			end
	  		end

	  		# duv: returns true if the user is the store manager for the GIVEN store, but false if given any other store.
	  		# use isStoreManager(user) if you just want to check if the user managers ANY stores.
	  		def isUserStoreManagerOf(user, store) 
	  			if user.nil? || store.nil?
	  				return false
	  			else 
	  				return user.has_role? :storemanager, store
	  			end
	  		end

	  		# dvu: is this user a store manager for ANY stores?
	  		def isStoreManager(user) 	  			
	  			if user.nil?
	  				return false
	  			else
	  				# returns all stores that this user is a storemanager of
	  				stores = Store.with_role(:storemanager, user)
	  				if stores.empty? #returns empty array, not nil
	  					return false
	  				else 
	  					return true
	  				end
	  			end
	  		end

	  		# this is lame that cancan + rollify force me to do these, but oh well!
	  		def canManageStore(user, store)
	  			
	  			if user.nil? || store.nil?
	  				return false
	  			end

	  			if isUserStoreManagerOf(user,store) || isUserStoreOwnerOf(user,store) || user.has_role?(:admin)
	  				return true
	  			else
	  				return false
	  			end
	  		end

	  		# dvu: don't much like this.  If a user is not logged in, they can still view the write review button, so that
	  		# when they click on it, they will get a login/registration prompt.  But the logic seems odd to me.  

	  		# Users can only write 1 review per store
	  		# Store manager & store owner cannot review their own store
	  		# return true or a string reason as to why they cannot, the string will be rendered in a tooltip.
	  		def canViewWriteReviewButton(user, store)
	  			if store.nil?
	  				return false
	  			end

	  			if user.nil?
	  				return true
	  			end
	  			if isStoreManager(user) || isStoreOwner(user)
	  				return "store managers cannot review stores"
	  			end

	  			previousreview = store.store_reviews.find_by user_id: user.id
	  			if previousreview.nil?
	  				return true
	  			else
	  				return "you've already reviewed this store"
	  			end

	  		end
		end #class
	end
end