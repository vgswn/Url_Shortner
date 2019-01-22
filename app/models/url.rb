class Url < ApplicationRecord
	validates :long_url,uniqueness: true
	after_create :start_background_processing 

	def self.shorten_url(params)
		begin
			@prefix = "https://www.vg.sw.n/"

			puts "inside model url"
	        @entry = Url.new(:long_url=>params[:long_url])
	        @short_url=UrlsHelper.md5hash(params[:long_url])
	        puts "inside model url"
	        @short_url=@prefix+UrlsController.check_collision_md5(@short_url)
	        puts "inside model url"
	        @entry.domain = params[:domain]
	        @entry.long_url = params[:long_url]
	        @entry.short_url = @short_url
	        @entry.save!
	        return {"Status"=>"Success","short_url"=> @short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}
	        

	    rescue Exception => e
	      @row  =	Rails.cache.fetch(params[:long_url]+params[:domain], :expires_in => 5.minutes) do 
	      			Url.where(long_url: params[:long_url]).first
	  				end

	      if @row[:short_url] == nil
	      	@row.destroy
	      	return {"Status" => "Error","Error"=>"Something Went Wrong"}

	      else
	      	return {"Status"=>"Already Exists","short_url"=>@row[:short_url],"long_url"=>@row[:long_url],"domain"=>@row[:domain]}
	      end

	    end
	end

	def self.short_url(params)
		@prefix = "https://www.vg.sw.n/"

	    if params[:short_url].start_with?("http") == false
	          params[:short_url]=@prefix+params[:short_url]
	    end

    	begin

	     	@row=	Rails.cache.fetch(params[:short_url], :expires_in => 5.minutes) do
	     			Url.where(short_url: params[:short_url]).first
	     			end

	     	return {"Status"=>"OK !","long_url"=>@row[:long_url],"domain"=>@row[:domain],"short_url"=>params[:short_url]}

    	rescue Exception => e
    		return {"Status"=>"Nothing Found !"}
    	end
	
	end





  def start_background_processing
  	puts "performing async"
    UrlWorker.perform_async({url_id: self.id})
    puts "added in queue"


    #UrlWorker.perform_in(5.minutes.from_now, {post_id: self.id})
  end


end
