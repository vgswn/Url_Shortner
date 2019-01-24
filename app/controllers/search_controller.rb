class SearchController < ApplicationController
  def show
  	@urls = Url.search(params.fetch(:q,"*"))
  end
  def search
  end
end
