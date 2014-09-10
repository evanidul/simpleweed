module Simpleweed
	module Subscription
		
		class Subscriptionservice

			@@plan_name = ['','gram','quarter ounce', 'ounce']
			@@plan_cost_per_month = ['','19','99','299']

			@@feature_to_plan_hash = Hash.new
			@@feature_to_plan_hash["store-address-contact-hours"] = 1
			@@feature_to_plan_hash["ratings-reviews"] = 1
			@@feature_to_plan_hash["member-alerts"] = 1
			@@feature_to_plan_hash["store-menu"] = 1

			@@feature_to_plan_hash["store-promo"] = 2
			@@feature_to_plan_hash["store-description"] = 2
			@@feature_to_plan_hash["store-features"] = 2
			@@feature_to_plan_hash["store-image-hosting"] = 2
			@@feature_to_plan_hash["store-announcements"] = 2

			@@feature_to_plan_hash["store-daily-specials"] = 3
			@@feature_to_plan_hash["store-first-time-patient-deals"] = 3
			@@feature_to_plan_hash["item-expanded-view"] = 3
			@@feature_to_plan_hash["item-promotions"] = 3			


			def getPlanNameFromID(id)				
				return @@plan_name[id]
			end

			def getPlanCostPerMonthFromID(id)
				return @@plan_cost_per_month[id]
			end

			def getPlanForFeature(featureName)
				return @@feature_to_plan_hash[featureName]
			end

			def canStoreUseFeature(store, featureName)
				
				if store.blank?
					return false
				end

				if store.plan_id.blank?
					return false
				end

				storeplanSufficient = store.plan_id >= getPlanForFeature(featureName)
				
				if storeplanSufficient
					return true
				else
					return false
				end
			end

		end #class
	end
end