module ApplicationHelper

 	#dvu: registration modal
	def resource_name
		:user
	end

	#dvu: registration modal
	def resource
		@resource ||= User.new
	end

	#dvu: registration modal
	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end
end
