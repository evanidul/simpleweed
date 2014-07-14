class Admin::FlagsController < ApplicationController

	def index
		@flaggings = Flaggings.all
	end

	
end
