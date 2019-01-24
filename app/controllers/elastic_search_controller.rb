class ElasticSearchController < ApplicationController
 	
 	def show
 		puts params
 		@urls = params["array"]
 	end
 	def retrieve
 		@urls = Url.search(params[:q]).records.ids
 		if @urls.empty?
	    	flash[:error] = "Not found anything"
	    	redirect_to search_path
 	else
 		@arr = Array.new
 		@urls.each do |url|
 			@row = Url.find(url)
 			@temp= Hash.new
 			@temp[:long_url] = @row[:long_url]
 			@temp[:short_url] = @row[:short_url]
 			@temp[:domain] = @row[:domain]
 			@arr << @temp
 		end
 		@hash = Hash.new
 		@hash["array"] = @arr
 		puts @hash
 		redirect_to elastic_search_show_path(@hash)
 	end
end

 	def search
 		
	end
end
