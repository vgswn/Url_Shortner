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


		@mode = params[:mode]+".trigram"
		#binding.pry
		@urls = Url.__elasticsearch__.search(
			{
			  query: {
			      bool: {
			          must: [
			              {
			                  term: {
			                      "#{@mode}":"#{params[:q]}"
			                  }
			              }
			             ]
			      }
			  }
			}
			).records

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
