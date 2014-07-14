require 'test_helper'
 
# Tests our integraiton with https://github.com/medihack/make_flaggable at a model level.  Does not test at a view level.

class FlagTests < ActiveSupport::TestCase

	test "basic flag test" do
		user = User.new(:username => 'user1' ,:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')
		user.save
		user.add_role :admin # sets a global role
		result = user.has_role? :admin

		user2 = User.new(:username => 'user2' ,:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password')
		user2.save

		user3 = User.new(:username => 'user3', :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password')
		user3.save

		assert_equal( true, result, 'User should have admin role assigned but does not')

		feed = Feed.new(:name => 'feedone')
		feed.save

		feed_post =  feed.feed_posts.create(:title => 'buy viagara', :post => 'some link to buy viagara')		
		feed_post.user = user
		feed_post.save		

		feed_post2 =  feed.feed_posts.create(:title => 'legit post', :post => 'i love pot')		
		feed_post2.user = user2
		feed_post2.save		

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
		


		assert_equal(feed.feed_posts.count, 2)

		reason = "this is spam!"
		reason2 = "i hate this review"
		# flag! throws an AlreadyFlaggedError is it's flagged already
		user.flag!(feed_post, reason)
		user.flag!(store_review, reason2)

		# get all flags on a post
		all_flags_for_first_post = feed_post.flaggings
		assert_equal(all_flags_for_first_post.first.reason, reason)

		# get all flags on 2nd post
		all_flags_for_second_post = feed_post2.flaggings
		assert_equal(all_flags_for_second_post.count, 0)

		# get all flags for first review
		all_flags_for_first_review = store_review.flaggings
		assert_equal(all_flags_for_first_review.count, 1)
		assert_equal(all_flags_for_first_review.first.reason, reason2)

		all_flags_for_second_review = store_review2.flaggings
		assert_equal(all_flags_for_second_review.count, 0)

		# get flagger of the flag
		assert_equal(all_flags_for_first_post.first.flagger, user)

		# get flagger of first store review
		assert_equal(all_flags_for_first_review.first.flagger, user)

		# Returns true if the flagger flagged the flaggable, false otherwise.
		assert_equal(user.flagged?(feed_post), true )
		assert_equal(user.flagged?(feed_post2), false)
		assert_equal(user2.flagged?(feed_post), false)
		assert_equal(user2.flagged?(feed_post2), false)

		assert_equal(user.flagged?(store_review), true )
		assert_equal(user2.flagged?(store_review), false )
		assert_equal(user3.flagged?(store_review), false )

		# Return true if the flaggable was flagged by the flagger, false otherwise.
		assert_equal(feed_post.flagged_by?(user), true )
		assert_equal(feed_post.flagged_by?(user2), false )
		assert_equal(store_review.flagged_by?(user), true )
		assert_equal(store_review.flagged_by?(user2), false )
		assert_equal(store_review.flagged_by?(user3), false )

		# Returns true if the post was flagged by any flagger at all, false otherwise.
		assert_equal(feed_post.flagged?, true)
		assert_equal(feed_post2.flagged?, false )
		assert_equal(store_review.flagged?, true)

	end	

	
end