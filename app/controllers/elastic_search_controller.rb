class ElasticSearchController < ApplicationController
 	
 	def show
 		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end
 		@urls = params["array"]
 	end

 	
 	def retrieve
 		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end
		@urls = Url.custom_search(search_params)
 		if @urls.first ==nil
	    	flash[:error] = "Not found anything"
	    	redirect_to search_path
 	else
 		@arr = Array.new
 		@urls.each do |url|
 			@arr << url.as_indexed_json
 		end
 		@hash = Hash.new
 		@hash["array"] = @arr
 		redirect_to elastic_search_show_path(@hash)
 	end
end

 	def search
 		if session[:authenticate]!= true
			redirect_to home_index_path
		end
	end

private

	def search_params
		params.permit(:mode,:q)
	end


end
