
require 'net/http'
require 'uri'
require 'json'

class UrlsController < ApplicationController
  include HTTParty
	skip_before_action :verify_authenticity_token
	def shorten_url
		@prefix = "https://www.vg.sw.n/"

	    begin
	        puts params[:long_url]
	        @entry = Url.create(:long_url=>params[:long_url])
	        #@short_url=UrlsHelper.md5hash(params[:long_url])
	        #@short_url=@prefix+UrlsController.check_collision_md5(@short_url)

	        @base64=UrlsHelper.base10_base64(@entry[:id])
	        @short_url=@prefix+UrlsHelper.generate_hash(@base64) 
	        @entry.domain = params[:domain]
	        @entry.long_url = params[:long_url]
	        @entry.short_url = @short_url

	        @entry.save!
	        render json: {"Status"=>"Success","short_url"=> @short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}
	      
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
	      render json: {"Status"=>"OK !","long_url"=>@row[:long_url],"domain"=>@row[:domain],"short_url"=>params[:short_url]}

    	rescue Exception => e

      		render json: {"Status"=>"Nothing Found !"}
    	end
	end


	def long_to_short
		unless current_user
			redirect_to home_index_path
		end

	end

	def short_to_long
		unless current_user
			redirect_to home_index_path
		end

	end

	def show
		unless current_user
			redirect_to home_index_path
		else
			@result = params
		end
	end

	def show_shorten
		#puts "qazqaz"
		#puts params[:long_url]
		url = "http://localhost:3000/shorten-url?"+"domain="+params[:domain]+"&"+"long_url="+params[:long_url]
		puts url 
		uri = URI.parse(url)
		header = {'Content-Type': 'json'}
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri, header)

		@response = http.request(request)

		@result= @response.body
		@result=JSON.parse @result
		#@result[:long_url] = params[:long_url]
		#@result[:domain] = params[:domain]
		redirect_to urls_show_path(@result)

		#redirect_to urls_show_short_path(@result)
	end


	def show_short
		url = "http://localhost:3000/short-url?"+"short_url="+params[:short_url]
		uri = URI(url)
		#params = { :limit => 10, :page => 3 }
		#uri.query = URI.encode_www_form(params)
		@response = Net::HTTP.get_response(uri)
		#puts res.body if res.is_a?(Net::HTTPSuccess)


		

		@result= @response.body
		@result=JSON.parse @result
		puts @result
		#@result[:short_url] = params[:short_url]
		#@result[:domain] = params[:domain]
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

