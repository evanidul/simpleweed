module Simpleweed
	module Timedateutil
		class Timedateservice
			
			def sayHi
		      return "timedateservice"		   
	  		end

	  		# @Tested: rake test test/lib/simpleweed/timedateservice.rb
	  		# need to handle "Closed" case
	  		def getSecondsSinceMidnight(timestring)

	  			if !timestring.is_a? String
	  				return -1
	  			end

	  			#mutable strings lead to crazy bugs
	  			timestring.freeze	  			

				# .dup clones a string but unfreezes the cloned one
	  			timestringcopy = timestring.dup

	  			# 10:00am - 11:30pm
	  			
	  			if timestringcopy.include? "pm"
	  				timestringIsPm = true
	  			else 
	  				timestringIsPm = false
	  			end	

	  			#delete am and pm
	  			timestringcopy.sub! 'am' , ''
	  			timestringcopy.sub! 'pm' , ''	  			

	  			hoursAndMinutes = timestringcopy.split(':')
	  			#convert hours into number of seconds
	  			hoursInSeconds = hoursAndMinutes[0].to_i * 60 * 60
	  			minutesInSeconds = hoursAndMinutes[1].to_i * 60
	  			subtotal = hoursInSeconds + minutesInSeconds

	  			if timestringIsPm
	  				# if PM, add 12 hours to it.
	  				if hoursAndMinutes[0].strip == "12" # call .strip because 10:00am - 12:00am leads to " 12"
	  					return subtotal
	  				else 
	  					return subtotal + (12* 60 * 60) 
	  				end
	  			else 
	  				if hoursAndMinutes[0].strip == "12"
	  					return subtotal - (12 * 60 * 60)  # 12 am is midnight, so we should cancel out the 12 hours we added before.
	  				else 
	  					return subtotal;	
	  				end
	  			end

	  		end #getSecondsSinceMidnight

	  		def isStoreOpen(currenttime, store)
				dayint = currenttime.to_date.wday  
				secondsSinceMidnight = currenttime.seconds_since_midnight()

				case dayint
				when 0
					return doesTimeOccurDuringBusinessHours(store.storehourssundayopen, store.storehourssundayclosed, secondsSinceMidnight, store.storehourssaturdayopen, store.storehourssaturdayclosed )
				when 1
					return doesTimeOccurDuringBusinessHours(store.storehoursmondayopen, store.storehoursmondayclosed, secondsSinceMidnight, store.storehourssundayopen, store.storehourssundayclosed)
				when 2	
					return doesTimeOccurDuringBusinessHours(store.storehourstuesdayopen, store.storehourstuesdayclosed, secondsSinceMidnight, store.storehoursmondayopen, store.storehoursmondayclosed)
				when 3	
					return doesTimeOccurDuringBusinessHours(store.storehourswednesdayopen, store.storehourswednesdayclosed, secondsSinceMidnight, store.storehourstuesdayopen, store.storehourstuesdayclosed)
				when 4	
					return doesTimeOccurDuringBusinessHours(store.storehoursthursdayopen, store.storehoursthursdayclosed, secondsSinceMidnight, store.storehourswednesdayopen, store.storehourswednesdayclosed)
				when 5	
					return doesTimeOccurDuringBusinessHours(store.storehoursfridayopen, store.storehoursfridayclosed, secondsSinceMidnight, store.storehoursthursdayopen, store.storehoursthursdayclosed)
				when 6	
					return doesTimeOccurDuringBusinessHours(store.storehourssaturdayopen, store.storehourssaturdayclosed, secondsSinceMidnight, store.storehoursfridayopen, store.storehoursfridayclosed)

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
	  		def doesTimeOccurDuringBusinessHours(open, closed, current, previousDayOpen, previousDayClose)
	  			# if open == closed, this store is open 24 hours a day
	  			if open == closed 
	  				return true
	  			end

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