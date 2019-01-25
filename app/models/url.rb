class Url < ApplicationRecord
	validates :long_url,uniqueness: true
	validates :domain , presence: true
	validates_format_of :long_url , :with => /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}/
	after_create :start_background_processing 
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks
	index_name([Rails.env,base_class.to_s.pluralize.underscore].join('_'))


	mapping do
    indexes :short_url, type: 'text'
  end
	
	def as_indexed_json(options={})
	  	as_json(
	    	only: [:long_url, :short_url,:domain]
	  		)
	end



	def self.shorten_url(params)
		begin
			@prefix = "https://www.vg.sw.n/"
	        @entry = Url.create!(params)
			@prefix= Rails.cache.fetch(params[:domain], :expires_in => 5.minutes) do 
		  				 DomainPrefixHelper.find_domain_prefix(params[:domain])
		  				 end	        
		  	@short_url=UrlsHelper.md5hash(params[:long_url])
	        @short_url=UrlsHelper.check_collision_md5(@short_url)
			params[:short_url]=@short_url
			@entry.update_attributes(params)

	        return {"Status"=>"Success","short_url"=> @prefix+@short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}

	    rescue Exception => e
	    	if e.to_s.include? "invalid"
	    		puts e
	    		return {"Status" => "Error","Error"=>"Enter Valid Url"}
	    	elsif e.to_s.include? "blank"
	    		return {"Status" => "Error","Error"=>"Enter All Params"}

	    		

	    	else
		     	@row  =	Rails.cache.fetch(params[:long_url], :expires_in => 5.minutes) do 
		      			Url.where(long_url: params[:long_url]).first
		  				end
		  		@prefix= Rails.cache.fetch(params[:domain], :expires_in => 5.minutes) do 
		  				 DomainPrefixHelper.find_domain_prefix(@row[:domain])
		  				 end

		      	if @row[:short_url] == nil
		      	@row.destroy
		      		return {"Status" => "Error","Error"=>"Something Went Wrong"}
		      	else
		      		return {"Status"=>"Already Exists","short_url"=>@prefix+@row[:short_url],"long_url"=>@row[:long_url],"domain"=>@row[:domain]}
		      	end
		    end
	    end
	end

	def self.short_url(params)

		params[:short_url] = params[:short_url].strip
	    if params[:short_url].include?("/") == true
	          params[:short_url]=params[:short_url].split('/').last
	    end

    	begin
	     	@row=	Rails.cache.fetch(params[:short_url], :expires_in => 5.minutes) do
	     			Url.where(short_url: params[:short_url]).first
	     			end
			@prefix= Rails.cache.fetch(@row[:domain], :expires_in => 5.minutes) do 
		  				 DomainPrefixHelper.find_domain_prefix(@row[:domain])
		  				 end

	     	return {"Status"=>"OK !","long_url"=>@row[:long_url],"domain"=>@row[:domain],"short_url"=>@prefix+params[:short_url]}
    	rescue Exception => e
    		return {"Status"=>"Nothing Found !"}
    	end	
	end




  def start_background_processing
  	puts "performing async"
    UrlWorker.perform_async({url_id: self.id})
    puts "added in queue"
    #UrlWorker.perform_in(10.seconds.from_now,{post_id: self.id})
  end











end
