require 'test_helper'
 
# Tests our integraiton with https://github.com/medihack/make_flaggable at a model level.  Does not test at a view level.

class SubscriptionTests < ActiveSupport::TestCase

	test "basic subscription test" do		

		store1 = Store.new(:name => 'some store')
		test_plan_id = 1
		store1.plan_id = test_plan_id
		store1.save
		assert_equal(Store.count, 1)

		@subscriptionservice = Simpleweed::Subscription::Subscriptionservice.new

		test_plan_name = @subscriptionservice.getPlanNameFromID(test_plan_id)
				
		assert_equal( 'starter', test_plan_name, 'mismatched plan')

		test_plan_cost = @subscriptionservice.getPlanCostPerMonthFromID(test_plan_id)

		assert_equal( '19', test_plan_cost, 'mismatched plan cost')		

		test_plan_for_feature = @subscriptionservice.getPlanForFeature("store-address-contact-hours")

		assert_equal( 1, test_plan_for_feature, 'mismatched plan to feature')				

		test_plan_for_feature2 = @subscriptionservice.getPlanForFeature("store-daily-specials")		

		assert_equal( 3, test_plan_for_feature2, 'mismatched plan to feature')

		test_can_use_address_feature = @subscriptionservice.canStoreUseFeature(store1,"member-alerts")

		assert_equal( true, test_can_use_address_feature, 'store should be able to use this feature')

		test_can_use_address_feature2 = @subscriptionservice.canStoreUseFeature(store1,"store-promo")		

		assert_equal( false, test_can_use_address_feature2, 'store should not be able to use this feature' )

	end



end