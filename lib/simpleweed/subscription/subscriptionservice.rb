module Simpleweed
	module Subscription
		
		class Subscriptionservice

			@@plan_name = ['','gram','quarter ounce', 'ounce']
			@@plan_cost_per_month = ['','9','99','299']

			def getPlanNameFromID(id)				
				return @@plan_name[id]
			end

			def getPlanCostPerMonthFromID(id)
				return @@plan_cost_per_month[id]
			end

		end #class
	end
end