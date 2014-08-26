module Simpleweed
	module Badge

		# dvu: pretty dumb service.  I just didn't want to define @@badge_description over and over in the views, so I stuck
		# it in a class
		
		class Badgeservice

			@@badge_description = Hash.new
			@@badge_description["b"] = "buy one get one"
			@@badge_description["ts"] = "top shelf: the best of the best"
			@@badge_description["pr"] = "private reserve: only sold here"
			@@badge_description["o"] = "organic: grown organically"
			@@badge_description["sf"] = "sugar free: no sugar in this product"
			@@badge_description["gf"] = "gluten free: no gluten in this product"
			@@badge_description["ss"] = "super size: get a little extra"

			def getBadgeDescription(badgeStr)
				return @@badge_description[badgeStr]
			end

		end #class
	end
end