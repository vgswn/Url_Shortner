class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  
  def long_url_to_short_url
  end

  def short_url_to_long_url
  end

  def show
  end

  def api_post_shorten_url
    params[:long_url]=NormalizeUrl.process(params[:long_url])
    params[:domain]=Domainatrix.parse(params[:long_url]).domain
    puts params[:domain]
    render json: Url.shorten_url(url_params)
  end

  def api_get_short_url
    if !params[:short_url]
      return {"Status" => "Error","Error"=>"Enter All Params"}
    end
    params[:short_url] = params[:short_url].strip
    if params[:short_url].include?("/") == true
      params[:short_url]=params[:short_url].split('/').last
    end
    render json: Url.short_url(url_params)
  end

  def convert_long_url_to_short_url
    #Rails.cache.clear
    if params[:long_url] == ""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_long_url_to_short_url_path
    else
      params[:long_url]=NormalizeUrl.process(params[:long_url])
      params[:domain]=Domainatrix.parse(params[:long_url]).domain
      puts params[:domain]
      @result = Url.shorten_url(url_params)
      render '/urls/show'
    end
  end

  def retrieve_short_url_to_long_url
    if params[:short_url]==""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_short_url_to_long_url_path
    else
      params[:short_url] = params[:short_url].strip
      if params[:short_url].include?("/") == true
        params[:short_url]=params[:short_url].split('/').last
      end
      @result = Url.short_url(url_params)
      render '/urls/show'
    end
  end

private
  def url_params
    params.permit(:domain,:long_url,:short_url)
  end
end

