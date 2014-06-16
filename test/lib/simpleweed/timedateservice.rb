require 'test_helper'
 
class Timedateservice < ActiveSupport::TestCase

	# test "getSecondsSinceMidnight 1am" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "1:00 am"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 3600, result, 'Expected 3600 to be result')
	# end

	# test "getSecondsSinceMidnight non-string returns -1" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = 12
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( -1, result, 'non-strings should return -1 but didnt')
	# end

	# test "getSecondsSinceMidnight 8:30am" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "8:30 am"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 30600, result, 'Expected 30600 to be result')
	# end

	# test "getSecondsSinceMidnight 1:00 pm" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "1:00 pm"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 46800, result, 'Expected 46800 to be result')
	# end

	# test "getSecondsSinceMidnight 10:45 pm" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "10:45 pm"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 81900, result, 'Expected 81900 to be result')
	# end

	# test "getSecondsSinceMidnight 12:00 am (midnight)" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "12:00 am"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 0, result, 'Expected 0 to be result')
	# end

	# test "getSecondsSinceMidnight 12:15 am (midnight)" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "12:15 am"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 900, result, 'Expected 900 to be result')
	# end

	# test "getSecondsSinceMidnight 12:00 pm (noon)" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "12:00 pm"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 12 * 60 * 60, result,'Expected 43,200 to be result')
	# end

	# test "getSecondsSinceMidnight 12:35 pm (noon)" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "12:35 pm"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 45300, result, 'Expected 45,300 to be result')
	# end

	# test "getSecondsSinceMidnight from actual parsed string" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = "6:00am - 12:00am"
	# 	split =  testString.split("-")
	# 	openOrig = split[0]
	# 	closedOrig = split[1]

	# 	assert_equal( " 12:00am", closedOrig, "Expected 12:00am as string")

	# 	open = service.getSecondsSinceMidnight(openOrig)
	# 	closed = service.getSecondsSinceMidnight(closedOrig)     		
		
	# 	assert_equal( " 12:00am", closedOrig, "Expected 12:00am as string")
	# 	assert_equal( 21600, open, 'Expected 21600 to be result')
	# 	assert_equal( 0, closed, 'Expected 0 to be result')
	# end

	# test "getSecondsSinceMidnight 12:00 am (midnight), with space in front" do
	# 	service = Simpleweed::Timedateutil::Timedateservice.new
	# 	testString = " 12:00 am"
	# 	result = service.getSecondsSinceMidnight(testString)
	# 	assert_equal( 0, result, 'Expected 0 to be result')
	# end
	
	##
	## doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
	##

	test "it's 12AM.  The store hours are 1:30PM - 8PM.  The store was closed yesterday, store should be closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 0 * 60 * 60 #12AM
		open = (13 * 60 * 60) + 30 #1:30PM
		closed = 20 * 60 * 60 # 8 PM
		previousDayOpen = nil
		previousDayClose = nil
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 12 AM')
	end

	# 5AM - 3AM store
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

	test "it's 9:15AM. The stores hours are 5AM - 3AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (9 * 60 * 60) + (15 * 60) #9:15AM
		open = 5 * 60 * 60 #5AM
		closed = 3 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 9:15AM but is not')
	end

	test "it's 12PM. The stores hours are 5AM - 3AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (12 * 60 * 60) #12 PM
		open = 5 * 60 * 60 #5AM
		closed = 3 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 12:00PM but is not')
	end

	test "it's 12AM. The stores hours are 5AM - 3AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 0 #12 AM
		open = 5 * 60 * 60 #5AM
		closed = 3 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 12:00AM but is not')
	end


	# 5AM - 12AM store
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

	test "it's 9:50AM.  The stores hours are 5AM - 12AM. The store should be open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (9 * 60 * 60) + (50 *60) #09:50AM
		open = 5 * 60 * 60 #5AM
		closed = 0 #12AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 0 #12AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 09:50AM but is not')
	end	

	test "it's 12:50AM.  The stores hours are 5AM - 12AM. The store should be closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (50 *60) #12:50AM
		open = 5 * 60 * 60 #5AM
		closed = 0 #12AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 0 #12AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is close at 12:50AM but is not')
	end	

	# 5AM - 5AM store, 24 hour store
	test "it's 2AM.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 2 * 60 * 60 #2AM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #5AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 2AM but is not')
	end	
	
	test "it's 5AM.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 5 * 60 * 60 #5AM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 5AM but is not')
	end	

	test "it's 4:59AM.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (4 * 60 * 60) + (59 *60) #4:59AM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 4:59AM but is not')
	end	

	test "it's 5:01AM.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (5 * 60 * 60) + (1 *60) #5:01AM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 5:01AM but is not')
	end	

	test "it's noon.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (12 * 60 * 60)  #12:00 PM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 12:00PM but is not')
	end	

	test "it's midnight.  The stores hours are 5AM - 5AM. The store is always open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 0 # 12:00 AM
		open = 5 * 60 * 60 #5AM
		closed = 5 * 60 * 60 #3AM
		previousDayOpen = 5 * 60 * 60 #5AM
		previousDayClose = 5 * 60 * 60 #5AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 12:00AM but is not')
	end	

	# 8AM - 5PM store
	test "it's midnight.  The stores hours are 8AM - 5PM. The store is closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 0 # 12:00 AM
		open = 8 * 60 * 60 #8AM
		closed = 20 * 60 * 60 #8PM
		previousDayOpen = 8 * 60 * 60 #8AM
		previousDayClose = 20 * 60 * 60 #8PM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 12:00AM but is not')
	end	

	test "it's noon.  The stores hours are 8AM - 5PM. The store is open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 12 * 60 * 60 # 12:00 PM
		open = 8 * 60 * 60 #8AM
		closed = 20 * 60 * 60 #8PM
		previousDayOpen = 8 * 60 * 60 #8AM
		previousDayClose = 20 * 60 * 60 #8PM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 12:00PM but is not')
	end	

	test "it's 7AM.  The stores hours are 8AM - 5PM. The store is closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = 7 * 60 * 60 # 7:00 AM
		open = 8 * 60 * 60 #8AM
		closed = 20 * 60 * 60 #8PM
		previousDayOpen = 8 * 60 * 60 #8AM
		previousDayClose = 20 * 60 * 60 #8PM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 07:00AM but is not')
	end	

	test "it's 8:01AM.  The stores hours are 8AM - 5PM. The store is open" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (8 * 60 * 60) + (1 * 60) # 8:51 AM
		open = 8 * 60 * 60 #8AM
		closed = 20 * 60 * 60 #8PM
		previousDayOpen = 8 * 60 * 60 #8AM
		previousDayClose = 20 * 60 * 60 #8PM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 8:01AM but is not')
	end	

	# Store is closed sundays, but open saturdays 
	test "it's 8:01AM Sunday.  The store is closed sunday, but was open Saturday from 10AM-8PM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (8 * 60 * 60) + (1 * 60) # 8:51 AM
		open = -1 #closed
		closed = -1 #closed
		previousDayOpen = 10 * 60 * 60 #10AM
		previousDayClose = 20 * 60 * 60 #8PM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 8:01AM but is not')
	end	
	
	test "it's 2:01AM Sunday.  The store is closed sunday, but was open Saturday from 10AM-3AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (2 * 60 * 60) + (1 * 60) # 2:01 AM
		open = -1 #closed
		closed = -1 #closed
		previousDayOpen = 10 * 60 * 60 #10AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( true, result, 'This store is open at 2:01AM but is not')
	end	

	test "it's 3:01AM Sunday.  The store is closed sunday, but was open Saturday from 10AM-3AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (3 * 60 * 60) + (1 * 60) # 3:01 AM
		open = -1 #closed
		closed = -1 #closed
		previousDayOpen = 10 * 60 * 60 #10AM
		previousDayClose = 3 * 60 * 60 #3AM
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed at 3:01AM but is not')
	end	

	# store is closed weekends
	test "it's 10AM Sunday.  The store is closed sunday and saturday" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		current = (10 * 60 * 60) + (0 * 60) # 10:00 AM
		open = -1 #closed
		closed = -1 #closed
		previousDayOpen = -1
		previousDayClose = -1
		result = service.doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
		assert_equal( false, result, 'This store is closed on weekends but is not')
	end	

	#formatMilitaryTimeAsAMPM
	test "0:45 is 12:45 AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(0,45)
		assert_equal( "12:45 AM", result, "wrong result")
	end

	test "0,0 is 12:00 AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(0,0)
		assert_equal( "12:00 AM", result, "wrong result")
	end


	test "12:00 is 12:00 PM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(12,00)
		assert_equal( "12:00 PM", result, "wrong result")
	end

	test "13:15 is 1:15 PM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(13,15)
		assert_equal( "1:15 PM", result, "wrong result")
	end

	test "1:15 is 1:15 AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(1,15)
		assert_equal( "1:15 AM", result, "wrong result")
	end

	test "10:00 is 10:00 AM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(10,0)
		assert_equal( "10:00 AM", result, "wrong result")
	end

	test "22:00 is 10:00 PM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(22,0)
		assert_equal( "10:00 PM", result, "wrong result")
	end

	test "23:45 is 11:45 PM" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.formatMilitaryTimeAsAMPM(23,45)
		assert_equal( "11:45 PM", result, "wrong result")
	end

	#getMilitaryTimeFromAMPMString
	test "12:00am is [0,0]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("12:00am")
		assert_equal( 0, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end

	test "12:00am is [0,0], test with whitespace" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString(" 12:00am")
		assert_equal( 0, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end


	test "12:45am is [0,45]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("12:45am")
		assert_equal( 0, result[0], "wrong result")
		assert_equal( 45, result[1], "wrong result")
	end

	test "12:00pm is [12,0]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("12:00pm")
		assert_equal( 12, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end

	test "12:00pm is [12,0] with whitespace" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString(" 12:00pm")
		assert_equal( 12, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end

	test "12:45pm is [12,45]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("12:45pm")
		assert_equal( 12, result[0], "wrong result")
		assert_equal( 45, result[1], "wrong result")
	end

	test "1:00pm is [13,0]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("1:00pm")
		assert_equal( 13, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end

	test "1:00am is [1,0]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("1:00am")
		assert_equal( 1, result[0], "wrong result")
		assert_equal( 0, result[1], "wrong result")
	end

	test "8:45am is [8,45]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("8:45am")
		assert_equal( 8, result[0], "wrong result")
		assert_equal( 45, result[1], "wrong result")
	end

	test "8:45pm is [20,45]" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("8:45pm")
		assert_equal( 20, result[0], "wrong result")
		assert_equal( 45, result[1], "wrong result")
	end

	test "Closed returns Closed" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getMilitaryTimeFromAMPMString("Closed")
		assert_equal( "Closed", result, "wrong result")		
	end

	#getSecondsSinceMidnightGivenHourAndMinute
	test "0,24 (12:24AM) " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(0,24)
		assert_equal( 1440, result, "wrong result")		
	end

	test "1,24 (1:24AM) " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(1,24)
		assert_equal( 5040, result, "wrong result")		
	end

	test "10,24 (10:24AM) " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(10,24)
		assert_equal( 37440, result, "wrong result")		
	end

	test "22,24 (10:24PM) " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(22,24)
		assert_equal( 80640, result, "wrong result")		
	end

	test "12,24 (12:24PM) " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(12,24)
		assert_equal( 44640, result, "wrong result")		
	end

	test "pass in strings " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute("12",24)
		assert_equal( nil, result, "wrong result")		
	end

	test "invalid range " do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(24,0)
		assert_equal( nil, result, "wrong result")		
	end

	test "invalid range for minutes" do
		service = Simpleweed::Timedateutil::Timedateservice.new
		result = service.getSecondsSinceMidnightGivenHourAndMinute(0,60)
		assert_equal( nil, result, "wrong result")		
	end

end