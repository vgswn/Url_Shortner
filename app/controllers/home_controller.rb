class HomeController < ApplicationController
 def index
 end

 def generate_report
  if session[:authenticate] != true
 	render home_index_path
  end
 	@report = Report.get_report
 end
end


