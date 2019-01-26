class HomeController < ApplicationController
  def index
  	#session[:name] = "vipul"
  end
  def generate_report
  	@report = Report.get_report
  	if session[:authenticate] != true
			render home_index_path
	end
  end
 def typeahead
  render json: ["test"]
 #render json: {"short_url"=>"vipul"}

end
end
