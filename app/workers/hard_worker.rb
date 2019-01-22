class HardWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :post_queue

  def perform(*args)
  	puts args
    sleep(600) 
    # Do something

  end
end
