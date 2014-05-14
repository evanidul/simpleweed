class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	http_basic_authenticate_with name: "ddadmin", password: "idontreallysmoke"

	rescue_from CanCan::AccessDenied do |exception|
	redirect_to root_url, :alert => exception.message
	end

	after_filter :save_last_page_visit_url

	def save_last_page_visit_url
	  # store last url - this is needed for post-login redirect to whatever the user last visited.
	  if (request.fullpath != "/users/sign_in" &&
	      request.fullpath != "/users/sign_up" &&
	      request.fullpath != "/users/password" &&
	      request.fullpath != "/users/sign_out" &&
	      !request.xhr?) # don't store ajax calls
	    session[:previous_url] = request.fullpath 
	  end
	end

	def after_sign_in_path_for(resource)
	  session[:previous_url] || root_path
	end

	protected
	def authenticate_user!(message = nil)
		if user_signed_in?
		  return
		else
			if message.nil?
		  		redirect_to new_user_session_path
		  	else
		  		redirect_to new_user_session_path, :notice => message
		  	end
		  ## if you want render 404 page
		  ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
		end
	end

end
