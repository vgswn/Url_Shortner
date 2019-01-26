class UrlsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def shorten_url
			render json: Url.shorten_url(url_params)
	end

	def short_url
		render json: Url.short_url(params)
	end

	def long_to_short
		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end

	end

	def short_to_long
		if session[:authenticate]!= true
			redirect_to home_index_path
		end

	end

	def show
		if session[:authenticate]!= true
			redirect_to home_index_path
		else
			@result = params
		end
	end

	def show_shorten

		if params[:domain] == "" or params[:long_url] == ""
			puts "hey vipul"
			flash[:Error] = "Please Enter all Details"
			redirect_to urls_long_to_short_path
			#render home_index_path
		else
			@result = Url.shorten_url(url_params)
			redirect_to urls_show_path(@result)
	end

	end


	def show_short
		if params[:short_url]==""
			#puts "hey vipul"
			flash[:Error] = "Please Enter all Details"
			redirect_to urls_short_to_long_path
		else
		@result = Url.short_url(params)
		redirect_to urls_show_path(@result)
		end
	end
def autocomplete
		params[:term]="*"+params[:term]+"*"
 		@urls = Url.__elasticsearch__.search(
		      {
			    query: {
			        query_string: {
			            query: params[:term],
			            default_field: 'short_url'
			        }
			    }
				}
		    ).records
 		if @urls != nil
	 		@autocomplete = Array.new
	 		@urls.each do |url|
	 			@autocomplete << url.short_url
	 		end
	 		puts @autocomplete
			render json: @autocomplete
		end
	end
	


private
def url_params
	params.permit(:domain,:long_url,:short_url)
end

end

