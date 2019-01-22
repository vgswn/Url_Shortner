class HomeController < ApplicationController
  def index
  	#session[:name] = "vipul"
  end
  def generate_report
  	@report = Report.get_report
  	if session[:username]== nil
			render home_index_path
	end
  end
end
