class UrlsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def shorten_url
		@response = Url.shorten_url(params)
		if params[:action] == 'show_shorten'
	        	return @response
	    else
	        	render json: @response
	    end
	end

	def short_url
		@response = Url.short_url(params)
		if params[:action] == 'show_short'
	        	return @response
	    else
	        	render json: @response
	    end
    	
	end


	def long_to_short
		if session[:username]== nil
			redirect_to home_index_path
		end

	end

	def short_to_long
		if session[:username]== nil
			redirect_to home_index_path
		end

	end

	def show
		if session[:username]== nil
			redirect_to home_index_path
		else
			@result = params
		end
	end

	def show_shorten

		@result = shorten_url
		redirect_to urls_show_path(@result)
	end


	def show_short

		@result = short_url
		redirect_to urls_show_path(@result)
	end

	def self.check_collision_md5(short_url)

	    for i in 0..10 do 

	      @check=Url.where(short_url: short_url[i,5]).first
	      if @check == nil
	        short_url=short_url[i,5]
	        break
	      
	      end
	    
	    end

	    return short_url
  
  
  end

end

