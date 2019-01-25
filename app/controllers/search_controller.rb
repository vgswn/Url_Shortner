class SearchController < ApplicationController
  def show
  	query = params[:q]
  	if query == ''
  		@urls = Url.all
  	else
  		@urls = Url.search(params[:q])
  end
end

  def search

  end

  def autocomplete
  	puts "hey"
  	render json: ["Test"]
  end
end
