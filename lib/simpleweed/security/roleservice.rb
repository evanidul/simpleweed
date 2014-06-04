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
	  			if user.nil? || store.nil?
	  				return false
	  			else
	  				return user.has_role? :storeowner, store
	  			end
	  		end 

	  		def isStoreManager(user, store) 
	  			if user.nil? || store.nil?
	  				return false
	  			else 
	  				return user.has_role? :storemanager, store
	  			end
	  		end

	  		# this is lame that cancan + rollify force me to do these, but oh well!
	  		def canManageStore(user, store)
	  			
	  			if user.nil? || store.nil?
	  				return false
	  			end

	  			if isStoreManager(user,store) || isStoreOwner(user,store) || user.has_role?(:admin)
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
	  			if isStoreManager(user,store) || isStoreOwner(user,store)
	  				return "store managers cannot review their own stores"
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