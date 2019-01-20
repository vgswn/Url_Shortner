class UrlsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def shorten_url
		@prefix = "https://www.vg.sw.n/"

	    begin
	        
	        @entry = Url.create(:long_url=>params[:long_url])
	        @short_url=UrlsHelper.md5hash(params[:long_url])
	        @short_url=@prefix+UrlsController.check_collision_md5(@short_url)
	        @entry.domain = params[:domain]
	        @entry.long_url = params[:long_url]
	        @entry.short_url = @short_url
	        @entry.save!
	        render json: {"Status"=>"Success","short_url"=> @short_url}
	      
	    rescue Exception => e

	      @row= Url.where(long_url: params[:long_url]).first
	      if @row[:short_url] == nil
	        @row.destroy
	        render json:{"Status" => "Error","Error"=>"Something Went Wrong"}
	      else
	        render json:{"Status"=>"Already Exists","short_url"=>@row[:short_url]}
	      end

	    end

	end

	def short_url
		@prefix = "https://www.vg.sw.n/"

	    if params[:short_url].start_with?("http") == false
	          params[:short_url]=@prefix+params[:short_url]
	    end

    	begin

	      @row = Url.where(short_url: params[:short_url]).first
	      render json: {"Status"=>"OK !","long_url"=>@row[:long_url]}

    	rescue Exception => e

      		render json: {"Status"=>"Nothing Found !"}
    	end
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

