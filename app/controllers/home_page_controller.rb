class HomePageController < ApplicationController
  def index
  end

  def generate_report
    if params[:date].nil?
     @report = []
    else
      @report = Report.get_report(params[:date].to_s)
    end
  end
end

