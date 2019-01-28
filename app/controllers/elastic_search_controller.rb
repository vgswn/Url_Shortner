class ElasticSearchController < ApplicationController
 	
 	def show
 		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end
 		puts params
 		@urls = params["array"]
 	end

 	
 	def retrieve
 		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end
		#params[:q]="*"+params[:q]+"*"
		@urls = Url.search(params[:q]).records
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
 		puts @hash
 		redirect_to elastic_search_show_path(@hash)
 	end
end

 	def search
 		if session[:authenticate]!= true
			
			redirect_to home_index_path
		end
	end
	


end
