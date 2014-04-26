module Simpleweed
	module Timedateutil
		class Timedateservice
			
			def sayHi
		      return "timedateservice"		   
	  		end

	  		# rake test test/lib/simpleweed/timedateservice.rb
	  		def getSecondsSinceMidnight(timestring)
	  			# 10:00am - 11:30pm
	  			if !timestring.is_a? String
	  				return -1
	  			end
	  			
	  			if timestring.include? "pm"
	  				timestringIsPm = true
	  			else 
	  				timestringIsPm = false
	  			end	

	  			#delete am and pm
	  			timestring.sub! 'am' , ''
	  			timestring.sub! 'pm' , ''	  			

	  			hoursAndMinutes = timestring.split(':')
	  			#convert hours into number of seconds
	  			hoursInSeconds = hoursAndMinutes[0].to_i * 60 * 60
	  			minutesInSeconds = hoursAndMinutes[1].to_i * 60
	  			subtotal = hoursInSeconds + minutesInSeconds

	  			if timestringIsPm
	  				# if PM, add 12 hours to it.
	  				if hoursAndMinutes[0] == "12"
	  					return subtotal
	  				else 
	  					return subtotal + (12* 60 * 60) 
	  				end
	  			else 
	  				if hoursAndMinutes[0] == "12"
	  					return subtotal - (12 * 60 * 60)  # 12 am is midnight, so we should cancel out the 12 hours we added before.
	  				else 
	  					return subtotal;	
	  				end
	  			end

	  		end #getSecondsSinceMidnight

		end #class
	end
end