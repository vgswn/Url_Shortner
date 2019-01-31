class ElasticSearchController < ApplicationController
  
  def show #:nodoc:
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that gives search results using ElasticSearch    
  **End points:** Other services     
  **Routes** : Search_path     
  **Params:** 
              query,type: string ,required: yes, DESCRIPTION-> 'Query or Search Tag'  
              field,type: string,required: yes,  DESCRIPTION-> 'Field of Url in which Query has to be searched' 
  **Host:** localhost:3000    
=end
  def retrieve
    if params[:query] == ""
      flash[:Error] = "Please Enter Query"
      redirect_to search_path
    else
      params[:query] = params[:query].strip
      @urls = Url.custom_search(search_params)
      if !@urls.first
        flash[:Error] = "Not Found Anything"
        redirect_to search_path
      else
        render 'show'
      end
    end
  end

  def search #:nodoc:
  end

private
  def search_params
    params.permit(:field,:query)
  end
end
