require 'test_helper'
 
class Timedateservice < ActiveSupport::TestCase
	test "the truth" do
		assert true
	end

	test "getSecondsSinceMidnight 1am" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "1:00 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 3600, 'Expected 3600 to be result')
	end

	test "getSecondsSinceMidnight non-string returns -1" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = 12
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, -1, 'non-strings should return -1 but didnt')
	end

	test "getSecondsSinceMidnight 8:30am" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "8:30 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 30600, 'Expected 30600 to be result')
	end

	test "getSecondsSinceMidnight 1:00 pm" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "1:00 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 46800, 'Expected 46800 to be result')
	end

	test "getSecondsSinceMidnight 10:45 pm" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "10:45 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 81900, 'Expected 81900 to be result')
	end

	test "getSecondsSinceMidnight 12:00 am (midnight)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:00 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 0, 'Expected 0 to be result')
	end

	test "getSecondsSinceMidnight 12:15 am (midnight)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:15 am"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 900, 'Expected 900 to be result')
	end

	test "getSecondsSinceMidnight 12:00 pm (noon)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:00 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 12 * 60 * 60, 'Expected 43,200 to be result')
	end

	test "getSecondsSinceMidnight 12:35 pm (noon)" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		testString = "12:35 pm"
		result = service.getSecondsSinceMidnight(testString)
		assert_equal(result, 45300, 'Expected 45,300 to be result')
	end


end