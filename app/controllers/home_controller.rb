class HomeController < ApplicationController
  def index
  end

  def generate_report
      @report = Report.get_report
  end
end


