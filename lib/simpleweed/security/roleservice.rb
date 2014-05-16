module Simpleweed
	module Security
		class Roleservice
			
			def sayHi
		      return "roleservice"		   
	  		end

	  		# sets a role for a resource instance
	  		# replaces user.add_role :storeowner, store 
	  		# don't want that sort of code in the codebase as it may lead to holes if I mistype and grant global roles
	  		def addStoreOwnerRoleToStore(user, store)
	  			user.add_role :storeowner, store
	  		end 

	  		def removeStoreOwnerRoleFromUserAndStore(user, store)
	  			user.remove_role :storeowner, store
	  		end

	  		def findStoreOwnerForStore(store) 
	  			return User.with_role(:storeowner, store)
	  		end

		end #class
	end
end