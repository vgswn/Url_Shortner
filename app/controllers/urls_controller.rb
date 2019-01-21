class UrlsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def shorten_url
		@prefix = "https://www.vg.sw.n/"
		session[:name]="vipul"
	    begin
	        @entry = Url.new(:long_url=>params[:long_url])
	        @short_url=UrlsHelper.md5hash(params[:long_url])
	        @short_url=@prefix+UrlsController.check_collision_md5(@short_url)
	        @entry.domain = params[:domain]
	        @entry.long_url = params[:long_url]
	        @entry.short_url = @short_url
	        @entry.save!

	        if params[:action] == 'show_shorten'
	        	return {"Status"=>"Success","short_url"=> @short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}

	        else
	        	render json: {"Status"=>"Success","short_url"=> @short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}
	        
	        end

	    rescue Exception => e
	      @row  =	Rails.cache.fetch(params[:long_url]+params[:domain], :expires_in => 5.minutes) do 
	      			Url.where(long_url: params[:long_url]).first
	  				end

	      if @row[:short_url] == nil
	      	@row.destroy

	       	if params[:action] == 'show_shorten'
	       		return {"Status" => "Error","Error"=>"Something Went Wrong"}
	       	
	       	else
	        	render json:{"Status" => "Error","Error"=>"Something Went Wrong"}  
	        
	        end

	      else
	      	if params[:action] == 'show_shorten'
	      		return {"Status"=>"Already Exists","short_url"=>@row[:short_url],"long_url"=>@row[:long_url],"domain"=>@row[:domain]}
	      	
	      	else
	        	render json:{"Status"=>"Already Exists","short_url"=>@row[:short_url],"long_url"=>@row[:long_url],"domain"=>@row[:domain]} 
	        
	        end

	      end

	    end

	end

	def short_url
		puts session[:name]
		@prefix = "https://www.vg.sw.n/"

	    if params[:short_url].start_with?("http") == false
	          params[:short_url]=@prefix+params[:short_url]
	    end

    	begin

	     	@row=	Rails.cache.fetch(params[:short_url], :expires_in => 5.minutes) do
	     			Url.where(short_url: params[:short_url]).first
	     			end

	     	if params[:action] == 'show_short'
	      		return {"Status"=>"OK !","long_url"=>@row[:long_url],"domain"=>@row[:domain],"short_url"=>params[:short_url]}
	     	
	     	else
	      		render json: {"Status"=>"OK !","long_url"=>@row[:long_url],"domain"=>@row[:domain],"short_url"=>params[:short_url]}  
    	 	
    	 	end

    	rescue Exception => e

    		if params[:action] == 'show_short'
    			return {"Status"=>"Nothing Found !"}
    		
    		else
      			render json: {"Status"=>"Nothing Found !"} 
      		
      		end
    	
    	end
	
	end


	def long_to_short
		if session[:username]== nil
			redirect_to home_index_path
		end

	end

	def short_to_long
		if session[:username]== nil
			redirect_to home_index_path
		end

	end

	def show
		if session[:username]== nil
			redirect_to home_index_path
		else
			@result = params
		end
	end

	def show_shorten

		@result = shorten_url
		redirect_to urls_show_path(@result)
	end


	def show_short

		@result = short_url
		redirect_to urls_show_path(@result)
	end

	def self.check_collision_md5(short_url)

	    for i in 0..10 do 

	      @check=Url.where(short_url: short_url[i,5]).first
	      if @check == nil
	        short_url=short_url[i,5]
	        break
	      
	      end
	    
	    end

	    return short_url
  
  
  end

end

