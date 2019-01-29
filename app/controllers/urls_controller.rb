class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def api_post_shorten_url
    render json: Url.shorten_url(url_params)
  end

  def api_get_short_url
    render json: Url.short_url(params)
  end

  def long_url_to_short_url
  end

  def short_url_to_long_url
  end

  def show
      @result = params
  end

  def convert_long_url_to_short_url
    if params[:domain] == "" or params[:long_url] == ""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_long_url_to_short_url_path
    else
      @result = Url.shorten_url(url_params)
      render '/urls/show'
      #redirect_to urls_show_path(result)
    end
  end

  def retrieve_short_url_to_long_url
    if params[:short_url]==""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_short_url_to_long_url_path
    else
      @result = Url.short_url(url_params)
      render '/urls/show'
      #redirect_to urls_show_path(result)
    end
  end

private
  def url_params
    params.permit(:domain,:long_url,:short_url)
  end
end

