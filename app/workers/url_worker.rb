class UrlWorker
  include Sidekiq::Worker
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Worker that increase count of no_of_urls in the Report database asynchronously   
  **End points:** Other services       
  **Host:** localhost:3000    
=end
  def perform(*args)
    date = Date.today.to_s
    if Report.where(date:date).first
      report = Report.where(date:date).first
      report.no_of_urls = report.no_of_urls + 1
      report.save
    else
      Report.create(:date => date, :no_of_urls =>1)
    end
  end	
end