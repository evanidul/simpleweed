module Simpleweed
	module Timedateutil
		class Timedateservice
			
			def sayHi
		      return "timedateservice"		   
	  		end

	  		# rake test test/lib/simpleweed/timedateservice.rb
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
					return doesTimeOccurDuringBusinessHours(store.storehourssundayopen, store.storehourssundayclosed, secondsSinceMidnight);
				when 1	
					return doesTimeOccurDuringBusinessHours(store.storehoursmondayopen, store.storehoursmondayclosed, secondsSinceMidnight);
				when 2	
					return doesTimeOccurDuringBusinessHours(store.storehourstuesdayopen, store.storehourstuesdayclosed, secondsSinceMidnight);
				when 3	
					return doesTimeOccurDuringBusinessHours(store.storehourswednesdayopen, store.storehourswednesdayclosed, secondsSinceMidnight);
				when 4	
					return doesTimeOccurDuringBusinessHours(store.storehoursthursdayopen, store.storehoursthursdayclosed, secondsSinceMidnight);
				when 5	
					return doesTimeOccurDuringBusinessHours(store.storehoursfridayopen, store.storehoursfridayclosed, secondsSinceMidnight);
				when 6	
					return doesTimeOccurDuringBusinessHours(store.storehourssaturdayopen, store.storehourssaturdayclosed, secondsSinceMidnight);

				else
					return true #by default, just pretend it's open...
				end # case	

	  		end #isStoreOpen	

	  		### only works for CURRENT DAY!  so if they close at 3AM, 3AM is technically the next day and this method won't work.
	  		# open - seconds since midnigtht, open hours
	  		# closed - seconds since midnight
	  		# current time - passed as seconds since midnight
	  		def doesTimeOccurDuringBusinessHours(open, closed, current)
	  			return current.between?(open, closed)
	  		end #doesTimeOccurDuringBusinessHours

		end #class
	end
end