module Simpleweed
	module Timedateutil
		class Timedateservice
			
			def sayHi
		      return "timedateservice"		   
	  		end

	  		#given 0-23 hours as an int, 00-59 minutes as an int, return am/pm string
	  		def formatMilitaryTimeAsAMPM(hours, minutes)
	  			if hours.nil? || minutes.nil?
	  				return
	  			end
	  			ampm = "AM"
	  			h = hours

	  			if h >= 12 
			        h = hours-12;
			        ampm = "PM"
			    end
			    
			    if h == 0
			        h = 12
			    end

			    if minutes == 0
			    	minutes = "00"
			    end

			    return h.to_s + ":" + minutes.to_s + " " + ampm

	  		end

	  		# Needs to take 7:00AM and return 7,00.  Returns Closed as Closed
	  		def getMilitaryTimeFromAMPMString(datestring)
	  			if !datestring.is_a? String
	  				return nil
	  			end
	  			if datestring == "Closed"	  				
	  				return "Closed"
	  			end

	  			datestring.freeze	  			

				# .dup clones a string but unfreezes the cloned one
	  			datestringcopy = datestring.dup


	  			if datestringcopy.include? "pm"
	  				isPm = true
	  			else 
	  				isPm = false
	  			end	

	  			hoursAndMinutes = datestringcopy.split(':')
				
				hours = hoursAndMinutes[0].strip
				minutes = hoursAndMinutes[1].strip

				if hours == "12" && !isPm
					result = [0, minutes.to_i] # 12:00 AM is 00:00 in military time, to_i drops the pm string
					return result
				end		

				if hours == "12" && isPm
					result = [12, minutes.to_i] # 12:00 PM is 12:00 in military time					 
					return result
				end		

				hoursAsInt = hours.to_i
				if isPm
					result = [ hoursAsInt + 12 , minutes.to_i]
					return result
				else
					result = [ hoursAsInt, minutes.to_i]
					return result
				end
	  		end

	  		# @Tested: rake test test/lib/simpleweed/timedateservice.rb
	  		# need to handle "Closed" case
	  	# 	def getSecondsSinceMidnight(timestring)

	  	# 		if !timestring.is_a? String
	  	# 			return -1
	  	# 		end

	  	# 		if timestring == "Closed"
	  	# 			return -1
	  	# 		end

	  	# 		#mutable strings lead to crazy bugs
	  	# 		timestring.freeze	  			

				# # .dup clones a string but unfreezes the cloned one
	  	# 		timestringcopy = timestring.dup

	  	# 		# 10:00am - 11:30pm
	  			
	  	# 		if timestringcopy.include? "pm"
	  	# 			timestringIsPm = true
	  	# 		else 
	  	# 			timestringIsPm = false
	  	# 		end	

	  	# 		#delete am and pm
	  	# 		timestringcopy.sub! 'am' , ''
	  	# 		timestringcopy.sub! 'pm' , ''	  			

	  	# 		hoursAndMinutes = timestringcopy.split(':')
	  	# 		#convert hours into number of seconds
	  	# 		hoursInSeconds = hoursAndMinutes[0].to_i * 60 * 60
	  	# 		minutesInSeconds = hoursAndMinutes[1].to_i * 60
	  	# 		subtotal = hoursInSeconds + minutesInSeconds

	  	# 		if timestringIsPm
	  	# 			# if PM, add 12 hours to it.
	  	# 			if hoursAndMinutes[0].strip == "12" # call .strip because 10:00am - 12:00am leads to " 12"
	  	# 				return subtotal
	  	# 			else 
	  	# 				return subtotal + (12* 60 * 60) 
	  	# 			end
	  	# 		else 
	  	# 			if hoursAndMinutes[0].strip == "12"
	  	# 				return subtotal - (12 * 60 * 60)  # 12 am is midnight, so we should cancel out the 12 hours we added before.
	  	# 			else 
	  	# 				return subtotal;	
	  	# 			end
	  	# 		end

	  	# 	end #getSecondsSinceMidnight

	  		# 0-23 for hours, 0-59 for minutes
	  		def getSecondsSinceMidnightGivenHourAndMinute(hour, minute)
	  			if  (!hour.is_a? Integer) || (!minute.is_a? Integer)
	  				#error
	  				return nil;
	  			end

	  			if (hour > 23) || (minute > 59)
	  				return nil;
	  			end

	  			if ( hour < 0 ) || (minute < 0)
	  				return nil
	  			end

	  			hourAsSeconds = hour * 60 *60
	  			minuteAsSeconds = minute * 60
	  			return hourAsSeconds + minuteAsSeconds


	  		end

	  		def isStoreOpen(currenttime, store)
				dayint = currenttime.to_date.wday  
				secondsSinceMidnight = currenttime.seconds_since_midnight()

				case dayint
				when 0
					if store.sundayclosed
						if store.saturdayclosed
							return false
						end
						# if store is closed, we still need to call doesTimeOccurDuringBusinessHours with -1,-1 to tell it that
						# the store is closed today, but might be open from yesterday (for late closes, 3 am...)
						return doesTimeOccurDuringBusinessHours(
						-1,  
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayopenhour, store.storehourssaturdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayclosehour, store.storehourssaturdaycloseminute)
						)
					else 
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayopenhour, store.storehourssundayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayclosehour, store.storehourssundaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayopenhour, store.storehourssaturdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayclosehour, store.storehourssaturdaycloseminute)
						)
					end
				when 1
					if store.mondayclosed
						if store.sundayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayopenhour, store.storehourssundayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayclosehour, store.storehourssundaycloseminute)
						)
					else	
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayopenhour, store.storehoursmondayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayclosehour, store.storehoursmondaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayopenhour, store.storehourssundayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssundayclosehour, store.storehourssundaycloseminute)
						)
					end
				when 2
					if store.tuesdayclosed
						if store.mondayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayopenhour, store.storehoursmondayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayclosehour, store.storehoursmondaycloseminute) 						
						)
					else	
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayopenhour, store.storehourstuesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayclosehour, store.storehourstuesdaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayopenhour, store.storehoursmondayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursmondayclosehour, store.storehoursmondaycloseminute) 						
						)
					end
				when 3
					if store.wednesdayclosed
						if store.tuesdayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayopenhour, store.storehourstuesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayclosehour, store.storehourstuesdaycloseminute)	
						)
					else	
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayopenhour, store.storehourswednesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayclosehour, store.storehourswednesdaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayopenhour, store.storehourstuesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourstuesdayclosehour, store.storehourstuesdaycloseminute)	
						)
					end
				when 4	
					if store.thursdayclosed
						if store.wednesdayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayopenhour, store.storehourswednesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayclosehour, store.storehourswednesdaycloseminute)						
						)
					else 	
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayopenhour, store.storehoursthursdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayclosehour, store.storehoursthursdaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayopenhour, store.storehourswednesdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourswednesdayclosehour, store.storehourswednesdaycloseminute)						
						)
					end
				when 5	
					if store.fridayclosed
						if store.thursdayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayopenhour, store.storehoursthursdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayclosehour, store.storehoursthursdaycloseminute)						
						)
					else	
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayopenhour, store.storehoursfridayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayclosehour, store.storehoursfridaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayopenhour, store.storehoursthursdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursthursdayclosehour, store.storehoursthursdaycloseminute)						
						)
					end
				when 6	
					if store.saturdayclosed
						if store.fridayclosed
							return false
						end
						return doesTimeOccurDuringBusinessHours(
						-1,
						-1, 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayopenhour, store.storehoursfridayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayclosehour, store.storehoursfridaycloseminute)						
						)
					else
						return doesTimeOccurDuringBusinessHours(
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayopenhour, store.storehourssaturdayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehourssaturdayclosehour, store.storehourssaturdaycloseminute), 						
						secondsSinceMidnight, 
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayopenhour, store.storehoursfridayopenminute),
						getSecondsSinceMidnightGivenHourAndMinute(store.storehoursfridayclosehour, store.storehoursfridaycloseminute)						
						)
					end
				else
					return true #by default, just pretend it's open...
				end # case	

	  		end #isStoreOpen	


	  		# @Tested: rake test test/lib/simpleweed/timedateservice.rb	  		
	  		# open - seconds since midnigtht, open hours
	  		# closed - seconds since midnight
	  		# current time - passed as seconds since midnight
	  		# previousDayOpen - seconds since midnight
	  		# previousDayClose - seconds since midnight
	  		# the store is open 24 hours a day if open and closed are equal, and neither is -1
	  		# the store is closed all day if open and closed are both -1
	  		def doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
	  			# if open == closed, this store is open 24 hours a day
	  			if ((open == closed) && !((open == -1) && (closed == -1)))  # is the store open 24 hours a day?
	  				return true
	  			end

	  			if ((open == -1) && (closed == -1))   #the store is closed today..but we need to check if it's open from yesterday
	  				if previousDayClose < previousDayOpen  # .. check and see if the previous day's close is 3AM
	  																  #..and that 3 AM is before the open at 5 AM
	  					return current.between?(0, previousDayClose)  # if so, the store is still open if the current time is
	  																  #between 00:00 and the closing time (3AM)
	  				else
	  					return false												  
	  				end # if	

	  			end # if

	  			if current.between?(0, open)   #if the current time is between midnight and the previous day's opening hours..
	  				if previousDayClose < previousDayOpen  # .. check and see if the previous day's close is 3AM
	  																  #..and that 3 AM is before the open at 5 AM
	  					return current.between?(0, previousDayClose)  # if so, the store is still open if the current time is
	  																  #between 00:00 and the closing time (3AM)
	  				end # if	
	  			end # if

	  			if ( closed < open )
	  				return current.between?(open, 86400) # is closed is before open, it's something like 5AM - 3AM, so it's 
	  													 # open between 5AM and midnight
	  			else
	  				return current.between?(open, closed)
	  			end
	  		end #doesTimeOccurDuringBusinessHours

		end #class
	end
end