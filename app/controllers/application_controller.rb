class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	#http_basic_authenticate_with name: "ddadmin", password: "idontreallysmoke"

	rescue_from CanCan::AccessDenied do |exception|
	redirect_to root_url, :alert => exception.message
	end

	# add username to devise
	before_filter :configure_permitted_parameters, if: :devise_controller?

	after_filter :save_last_page_visit_url

	def save_last_page_visit_url
	  # store last url - this is needed for post-login redirect to whatever the user last visited.
	  # we want to ignore anything that is devise related, otherwise we get some pretty nasty bugs with devise flows
	  if (!(request.fullpath.include? "/users/") &&
	      !request.xhr?) # don't store ajax calls
	    session[:previous_url] = request.fullpath 
	  end
	end

	def after_sign_in_path_for(resource)
	  session[:previous_url] || root_path
	end

	protected
	# redirect a user to login page if they are not authenticated, pass them through if they are.  Pass in an optional message
	def authenticate_user!(message = nil, modal = false)
		if user_signed_in?
		  return true
		end

		if modal
			render "modals/login", layout: false
			return false
		end
		 
		if message.nil?
	  		redirect_to new_user_session_path and return false
	  	else
	  		redirect_to new_user_session_path, :notice => message and return false
	  	end
	
		  ## if you want render 404 page
		  ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
		
	end

	protected 
	def must_be_logged_on_as_store_manager
		if authenticate_user!("You must be logged in to complete this action")	
		
			@role_service = Simpleweed::Security::Roleservice.new
			if !@role_service.canManageStore(current_user, @store)
				#redirect_to error_authorization_store_path(@store)
				render "stores/error_authorization" and return
			else
				# SUCCESS: pass it through	
			end
		else 
			# not logged in, will redirect to login page
			return	
		end
	end

	protected
	def must_be_admin
		if authenticate_user!("You must be logged in to complete this action")	
			#@role_service = Simpleweed::Security::Roleservice.new
			if !current_user.has_role?(:admin)
				render "stores/error_authorization" and return
			else
				# SUCCESS: pass it through
			end
		else
			#not logged in, will redirect to login page
			return
		end
	end

	# add username to devise
	def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
	    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
	    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  	end

end
