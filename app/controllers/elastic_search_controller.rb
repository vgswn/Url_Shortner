class ElasticSearchController < ApplicationController
  
  def show
  end

  def retrieve
    if params[:query] == ""
      flash[:Error] = "Please Enter Query"
      redirect_to search_path
    end
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

  def search
  end

private
  def search_params
    params.permit(:field,:query)
  end
end
