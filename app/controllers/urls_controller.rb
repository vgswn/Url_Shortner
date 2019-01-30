class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  
  def long_url_to_short_url
  end

  def short_url_to_long_url
  end

  def show
  end

=begin
  **Common Name:** Process api post request for converting long url to short url
  **End points:** Other services
  **Request Type** : post
  **Routes** : shorten_url_path
  **url:** URI("localhost:3000/shorten-url/?long_url=https://www.makaan.com/vips")
  **Params:** long_url,type: string ,required: yes, DESCRIPTION-> 'Long Url that needs to be converted'
  **Content-Type:** application/json; charset=utf-8
  **Output Type:** JSON
  **Output Fields:** status,long_url,short_url,domain
  **Host:** localhost:3000
=end

  def api_post_shorten_url
    response = shorten_url(url_params)
    render json: response,status: response[:status]
  end

=begin
  **Common Name:** Process api get request for retrieving short url to long url
  **End points:** Other services
  **Request Type** : get
  **Routes** : short_url_path
  **url:** URI("localhost:3000/short-url?short_url=mk.com/1c2b052")
  **Params:** short_url,type: string ,required: yes, DESCRIPTION-> 'Short Url that finds the coresponding long url'
  **Content-Type:** application/json; charset=utf-8
  **Output Type:** JSON
  **Output Fields:** status,long_url,short_url,domain
  **Host:** localhost:3000
=end

  def api_get_short_url
    response = short_url(url_params)
    render json: response,status: response[:status]
  end


  def convert_long_url_to_short_url
    if params[:long_url] == ""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_long_url_to_short_url_path
    else
      params[:long_url] = params[:long_url].strip
      @result = shorten_url(url_params)
      render '/urls/show'
    end
  end

  def retrieve_short_url_to_long_url
    if params[:short_url]==""
      flash[:Error] = "Please Enter all Details"
      redirect_to urls_short_url_to_long_url_path
    else
      params[:short_url] = params[:short_url].strip
      @result = short_url(url_params)
      render '/urls/show'
    end
  end

private
  def url_params
    params.permit(:domain,:long_url,:short_url)
  end

  def shorten_url(params)
    errors,val = check_params(params)
    if !val
      return errors
    end
    params[:long_url] = params[:long_url].strip
    params[:domain]=Domainatrix.parse(params[:long_url]).domain
    domain_row,val = check_domain_valid_url(params[:domain])
    if !val
      return domain_row
    end
    prefix = domain_row[:prefix]
    url = Url.new(params)
    url.save
    errors = url.find_errors
    response_of_validity,val = check_valid_url(errors,params,prefix)
    if !val
      return response_of_validity
    end
    short_url=UrlsHelper.md5hash(params[:long_url])
    short_url=UrlsHelper.check_collision_md5(short_url)
    params[:short_url]=short_url
    url.update_attributes(params)
    return {
      status: :accepted,
      short_url:prefix+short_url,
      long_url:params[:long_url],
      domain:params[:domain]
    }
  end

  def short_url(params)
    errors,val = check_params(params)
    if !val
      return errors
    end
    params[:short_url] = params[:short_url].strip
    if params[:short_url].include?("/") == true
      params[:short_url]=params[:short_url].split('/').last
    end
    url= Url.where(params).first
    if url.nil?
      return {
        status: :not_found
        }
    else
      prefix = DomainPrefix.where(domain: url[:domain]).first[:prefix]
      return {
        status: :ok,
        long_url:url[:long_url],
        domain:url[:domain],
        short_url:prefix+url[:short_url]
      }
    end
  end

  def check_params(params)
    if params.empty?
      return {
      status: :bad_request,
      error: "Enter params"
      },false
    end
    params.each do |key,value|
      if value == ""
        return {
          status: :bad_request,
          error: "Enter params"
          },false
      end
    end
    return {},true
  end

  def check_domain_valid_url(domain)
    domain_row= DomainPrefix.find_prefix(domain)
      if domain_row == nil
       return {
                  status: :bad_request,
                  error: "Enter Valid Domain or Enter Valid Url"
              },false
      end
      return domain_row,true
  end

  def check_valid_url(errors,params,prefix)
    if (errors[:long_url]).to_s.include?("already")
        url_row = Url.where(long_url: params[:long_url]).first
        return {
              status: :already_reported,
              short_url:prefix+url_row[:short_url],
              long_url:url_row[:long_url],
              domain:url_row[:domain]
            },false
    elsif (errors[:long_url]).to_s.include?("invalid")
      return {
            status: :bad_request,
            error: "Enter Valid Url"
            },false
    else
      return {},true
    end
  end
end

