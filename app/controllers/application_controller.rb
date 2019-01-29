class ApplicationController < ActionController::Base
	before_action :check_session
def check_session
	#puts "here here"
	if session[:expires_at] != nil
	    if session[:expires_at] < Time.current
		    session[:username]=nil
		  	session[:authenticate]=false
		  	#render 'home/index'
		  	#redirect_to home_index_path
	     end
	 end
end

end

