require 'test_helper'
 
class Timedateservice < ActiveSupport::TestCase

	test "getSecondsSinceMidnight 1am" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "1:00 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 3600, result, 'Expected 3600 to be result')
	end

	test "getSecondsSinceMidnight non-string returns -1" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = 12
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( -1, result, 'non-strings should return -1 but didnt')
	end

	test "getSecondsSinceMidnight 8:30am" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "8:30 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 30600, result, 'Expected 30600 to be result')
	end

	test "getSecondsSinceMidnight 1:00 pm" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "1:00 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 46800, result, 'Expected 46800 to be result')
	end

	test "getSecondsSinceMidnight 10:45 pm" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "10:45 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 81900, result, 'Expected 81900 to be result')
	end

	test "getSecondsSinceMidnight 12:00 am (midnight)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:00 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 0, result, 'Expected 0 to be result')
	end

	test "getSecondsSinceMidnight 12:15 am (midnight)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:15 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 900, result, 'Expected 900 to be result')
	end

	test "getSecondsSinceMidnight 12:00 pm (noon)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:00 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 12 * 60 * 60, result,'Expected 43,200 to be result')
	end

	test "getSecondsSinceMidnight 12:35 pm (noon)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:35 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 45300, result, 'Expected 45,300 to be result')
	end

	test "getSecondsSinceMidnight from actual parsed string" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "6:00am - 12:00am"
		split =  testString.split("-")
		openOrig = split[0]
		closedOrig = split[1]

		assert_equal( " 12:00am", closedOrig, "Expected 12:00am as string")

		open = service.getSecondsSinceMidnight(openOrig)
		closed = service.getSecondsSinceMidnight(closedOrig)     		
		
		assert_equal( " 12:00am", closedOrig, "Expected 12:00am as string")
		assert_equal( 21600, open, 'Expected 21600 to be result')
		assert_equal( 0, closed, 'Expected 0 to be result')
	end

	test "getSecondsSinceMidnight 12:00 am (midnight), with space in front" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = " 12:00 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal( 0, result, 'Expected 0 to be result')
	end
	
	## doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
	test "it's 2AM.  The stores hours are 5AM - 3AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 2 * 60 * 60 #2AM
		open = 5 * 60 * 60 #5AM
		closed = 3 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 2AM but is not')
	end	

	test "it's 3:15AM. The stores hours are 5AM - 3AM. The store should be closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (3 * 60 * 60) + (15 * 60) #3:15AM
		open = 5 * 60 * 60 #5AM
		closed = 3 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 3:15AM but is not')
	end

	test "it's 2AM.  The stores hours are 5AM - 12AM. The store should be closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 2 * 60 * 60 #2AM
		open = 5 * 60 * 60 #5AM
		closed = 0 #12AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 0 #12AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 2AM but is not')
	end	

	test "it's 11:50PM.  The stores hours are 5AM - 12AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (23 * 60 * 60) + (50 *60) #11:50PM
		open = 5 * 60 * 60 #5AM
		closed = 0 #12AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 0 #12AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 11:50PM but is not')
	end	

end