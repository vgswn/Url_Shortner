class UrlWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :default
def perform(*args)
	#sleep(10) 
    puts args
    @date = Date.today.to_s
    puts @date
    if Report.where(date:@date).first
    	@report = Report.where(date:@date).first
    	@report.no_of_urls = @report.no_of_urls + 1
    	@report.save
	else
		Report.create(:date => @date, :no_of_urls =>1)
	end
    end	
end