module Simpleweed
	module Score
		class Scoreservice
			
			#numerator = rating * (votes + 1)
			#denominator = # votes + # of reviews
			# throw away reviews that have negative votes
			def calculate_stars_for_store(store)
			   	if store.nil?
			   	  	return
			   	end

			   	numerator = 0
		   		denominator = 0

			   	store.store_reviews.each do |store_review|
			   		if store_review.sum_votes >= 0			   			
			   			upvotes = store_review.sum_votes
			   			score = store_review.stars * (upvotes + 1)
			   			numerator = numerator + score
			   			denominator = denominator + (upvotes + 1)			   			
			   		end
			   	end

			   	if denominator == 0
			   		return 0
			   	end

			   	return numerator.to_f / denominator

		    end

		    def calculate_stars_for_item(item)
		    	if item.nil?
		    		return
		    	end

		    	numerator = 0
		   		denominator = 0

			   	item.store_item_reviews.each do |item_review|
			   		if item_review.sum_votes >= 0			   			
			   			upvotes = item_review.sum_votes
			   			score = item_review.stars * (upvotes + 1)
			   			numerator = numerator + score
			   			denominator = denominator + (upvotes + 1)			   			
			   		end
			   	end

			   	if denominator == 0
			   		return 0
			   	end

			   	return numerator.to_f / denominator
		    end

		end #class
	end
end