require 'test_helper'
 
# Tests our integraiton with Rollify at a model level.  Does not test at a view level.

class SocializationTest < ActiveSupport::TestCase

	test "user follows other users" do
		user1username = "user1"
		user1email = "user1@gmail.com"
		user1 = User.new(:username => user1username, :email => user1email, :password => 'password', :password_confirmation => 'password')
		user1.save
		
		user2username = "user2"
		user2email = "user2@gmail.com"
		user2 = User.new(:username => user2username, :email => user2email, :password => 'password', :password_confirmation => 'password')
		user2.save

		user3username = "user3"
		user3email = "user3@gmail.com"
		user3 = User.new(:username => user3username, :email => user3email, :password => 'password', :password_confirmation => 'password')
		user3.save

		user1.follow!(user2)
		user2.follow!(user1)
		user3.follow!(user1)
		user3.follow!(user2)
		# pluck: grabs ids at the query level, but not working for some reason
		#followees_ids_of_user1 = user1.followees(User).pluck(:id)
		# records stored in memory, and id is plucked
		
		#followees_ids_of_user2 = user2.followees(User).pluck(:id)

		# what users are you following?
		followees_ids_of_user1 = user1.followees(User).collect(&:username)  
		followees_ids_of_user2 = user2.followees(User).collect(&:username)  
		followees_ids_of_user3 = user3.followees(User).collect(&:username)  

		assert_equal( true, (followees_ids_of_user1.include? user2username), 'user1 is following user 2 but is not')
		assert_equal( true, (followees_ids_of_user2.include? user1username), 'user2 is following user 1 but is not')

		assert_equal( true, (followees_ids_of_user3.include? user1username), 'user3 is following user 1 but is not')
		assert_equal( true, (followees_ids_of_user3.include? user2username), 'user3 is following user 2 but is not')

	end	

	test "user follows other stores" do

		user1username = "user1"
		user1email = "user1@gmail.com"
		user1 = User.new(:username => user1username, :email => user1email, :password => 'password', :password_confirmation => 'password')
		user1.save
		
		user2username = "user2"
		user2email = "user2@gmail.com"
		user2 = User.new(:username => user2username, :email => user2email, :password => 'password', :password_confirmation => 'password')
		user2.save

		user3username = "user3"
		user3email = "user3@gmail.com"
		user3 = User.new(:username => user3username, :email => user3email, :password => 'password', :password_confirmation => 'password')
		user3.save

		@store_name = "My new store"
		@store_addressline1 = "7110 Rock Valley Court"
		@store_city = "San Diego"
		@store_ca = "CA"
		@store_zip = "92122"
		@store = Store.new(:name => @store_name , :addressline1 => @store_addressline1, :city => @store_city, :state => @store_ca, :zip => @store_zip)
		@store.save	

		user1.follow!(user2)
		user2.follow!(user1)
		user3.follow!(user1)
		user3.follow!(user2)

		user1.follow!(@store)
		user2.follow!(@store)

		followees_ids_of_user1 = user1.followees(User).collect(&:username)  
		followees_ids_of_user2 = user2.followees(User).collect(&:username)  
		followees_ids_of_user3 = user3.followees(User).collect(&:username)  

		assert_equal( true, (followees_ids_of_user1.include? user2username), 'user1 is following user 2 but is not')
		assert_equal( true, (followees_ids_of_user2.include? user1username), 'user2 is following user 1 but is not')

		assert_equal( true, (followees_ids_of_user3.include? user1username), 'user3 is following user 1 but is not')
		assert_equal( true, (followees_ids_of_user3.include? user2username), 'user3 is following user 2 but is not')

		store_followees_ids_of_user1 = user1.followees(Store).collect(&:name)  
		store_followees_ids_of_user2 = user2.followees(Store).collect(&:name)  

		assert_equal( true, (store_followees_ids_of_user1.include? @store_name), 'user1 is following store1 but is not')
		assert_equal( true, (store_followees_ids_of_user2.include? @store_name), 'user1 is following store1 but is not')

	end	


end