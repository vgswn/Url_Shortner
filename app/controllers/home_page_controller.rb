class HomePageController < ApplicationController
  def index #:nodoc:
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that gives No of Urls Created on a particular date    
  **End points:** Other services     
  **Routes** : home_page_generate_report_path     
  **Params:** 
              date,type: date ,required: yes, DESCRIPTION-> 'Date'  
  **Host:** localhost:3000    
=end
  def generate_report
    if params[:date].nil?
     @report = []
    else
      @report = Report.get_report(params[:date].to_s)
    end
  end
end

