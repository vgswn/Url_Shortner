class Url < ApplicationRecord
	validates :long_url,uniqueness: true
	after_create :start_background_processing 
  def start_background_processing
  	puts "performing async"
    UrlWorker.perform_async({url_id: self.id})
    puts "added in queue"


    #UrlWorker.perform_in(5.minutes.from_now, {post_id: self.id})
  end

end
