require 'test_helper'

class ScoreServiceTests < ActiveSupport::TestCase	

	test "basic store score test, no votes" do
		user = User.new(:username => 'user1' ,:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		user2 = User.new(:username => 'user2' ,:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password')
		user2.save

		user3 = User.new(:username => 'user3', :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password')
		user3.save

		assert_equal( true, result, 'User should have admin role assigned but does not')

		store1 = Store.new(:name => 'some store')
		store1.save
		assert_equal(Store.count, 1)

		store_review =  store1.store_reviews.create(:review => 'USER 2my review', :stars => 3)		
		store_review.user = user2
		store_review.save

		store_review2 =  store1.store_reviews.create(:review => 'user 3my review', :stars => 5)		
		store_review2.user = user3
		store_review2.save

		assert_equal(StoreReview.count, 2)
		
		@scoreservice = Simpleweed::Score::Scoreservice.new

		score = @scoreservice.calculate_stars_for_store(store1)
		assert_equal(score, 4)
	end	

	test "store with no reviews" do
		store1 = Store.new(:name => 'some store')
		store1.save
		assert_equal(Store.count, 1)
		
		@scoreservice = Simpleweed::Score::Scoreservice.new

		score = @scoreservice.calculate_stars_for_store(store1)
		assert_equal(score, 0)
	end	

	test "store with reviews which all have neg. votes" do
		user = User.new(:username => 'user1' ,:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		user2 = User.new(:username => 'user2' ,:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password')
		user2.save

		user3 = User.new(:username => 'user3', :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password')
		user3.save

		assert_equal( true, result, 'User should have admin role assigned but does not')

		store1 = Store.new(:name => 'some store')
		store1.save
		assert_equal(Store.count, 1)

		store_review =  store1.store_reviews.create(:review => 'USER 2my review', :stars => 3)		
		store_review.user = user2
		store_review.save

		store_review2 =  store1.store_reviews.create(:review => 'user 3my review', :stars => 5)		
		store_review2.user = user3
		store_review2.save

		assert_equal(StoreReview.count, 2)

		# downvote first review
		store_review_vote =  store_review.store_review_votes.create(:vote => -1)		
		store_review_vote.user = user
		store_review_vote.save

		# downvote 2nd review
		store_review_vote2 =  store_review2.store_review_votes.create(:vote => -1)		
		store_review_vote2.user = user
		store_review_vote2.save

		# reviews with negative votes shouldn't be calculated
		@scoreservice = Simpleweed::Score::Scoreservice.new
		score = @scoreservice.calculate_stars_for_store(store1)
		assert_equal(score, 0)

		# add another review
		store_review3 =  store1.store_reviews.create(:review => 'USER 1 review', :stars => 3)		
		store_review3.user = user
		store_review3.save
		score = @scoreservice.calculate_stars_for_store(store1)
		assert_equal(score, 3)
	end

	test "store with reviews with upvotes count more" do
		user = User.new(:username => 'user1' ,:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		user2 = User.new(:username => 'user2' ,:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password')
		user2.save

		user3 = User.new(:username => 'user3', :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password')
		user3.save

		assert_equal( true, result, 'User should have admin role assigned but does not')

		store1 = Store.new(:name => 'some store')
		store1.save
		assert_equal(Store.count, 1)

		store_review =  store1.store_reviews.create(:review => 'USER 2my review', :stars => 3)		
		store_review.user = user2
		store_review.save

		store_review2 =  store1.store_reviews.create(:review => 'user 3my review', :stars => 5)		
		store_review2.user = user3
		store_review2.save

		assert_equal(StoreReview.count, 2)

		# upvote 2nd review
		store_review_vote2 =  store_review2.store_review_votes.create(:vote => 1)		
		store_review_vote2.user = user
		store_review_vote2.save

		# reviews with negative votes shouldn't be calculated
		@scoreservice = Simpleweed::Score::Scoreservice.new
		score = @scoreservice.calculate_stars_for_store(store1)
		
		assert_equal(score, 4.333333333333333)

		# add another review
		store_review3 =  store1.store_reviews.create(:review => 'USER 1 review', :stars => 2)		
		store_review3.user = user
		store_review3.save
		score = @scoreservice.calculate_stars_for_store(store1)
		
		assert_equal(score, 3.75)
	end



	#### ITEM REVIEWS/ STARS

	# can't do it currently because sunspot doesn't run during unit tests (not even sure if we want it to)
	# whenever you add an item, code will notify sunspot and try to add the item to the index
	# this will fail in unit tests b/c no sunspot server is running so that call will fail
	# better to just cover this in selenium testing?



end