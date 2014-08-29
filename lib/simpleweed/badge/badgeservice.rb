module Simpleweed
	module Badge

		# dvu: pretty dumb service.  I just didn't want to define @@badge_description over and over in the views, so I stuck
		# it in a class
		
		class Badgeservice

			@@badge_description = Hash.new
			@@badge_description["b"] = "buy one, get one free"
			@@badge_description["ts"] = "high quality strains"
			@@badge_description["pr"] = "very high quality strains, limited quantities, exclusive"
			@@badge_description["o"] = "organic"
			@@badge_description["sf"] = "sugar-free"
			@@badge_description["gf"] = "gluten-free"
			@@badge_description["ss"] = "get a little extra for the same price"

			def getBadgeDescription(badgeStr)
				return @@badge_description[badgeStr]
			end

		end #class
	end
end