class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  
  def long_url_to_short_url
  end

  def short_url_to_long_url
  end

  def show
  end

  def api_post_shorten_url
    response = shorten_url(url_params)
    render json: response,status: response[:status]
  end

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
    if check_params(params).class == Hash.new.class
      return check_params(url_params)
    end
    params[:long_url] = params[:long_url].strip
    params[:domain]=Domainatrix.parse(params[:long_url]).domain
    domain_row = check_domain_valid_url(params[:domain])
    if domain_row.class == Hash.new.class
      return domain_row
    end
    prefix = domain_row[:prefix]
    url = Url.new(params)
    url.save
    errors = url.find_errors
    response_of_validity = check_valid_url(errors,params,prefix)
    if response_of_validity.class == Hash.new.class
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
    if check_params(params).class == Hash.new.class
      return check_params(params)
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
      }
    end
    params.each do |key,value|
      if value == ""
        return {
          status: :bad_request,
          error: "Enter params"
          }
      end
    end
    return true
  end

  def check_domain_valid_url(domain)
    domain_row= DomainPrefix.find_prefix(domain)
      if domain_row == nil
       return {
                  status: :bad_request,
                  error: "Enter Valid Domain or Enter Valid Url"
              }
      end
      return domain_row
  end

  def check_valid_url(errors,params,prefix)
    if (errors[:long_url]).to_s.include?("already")
        url_row = Url.where(long_url: params[:long_url]).first
        return {
              status: :already_reported,
              short_url:prefix+url_row[:short_url],
              long_url:url_row[:long_url],
              domain:url_row[:domain]
            }
    elsif (errors[:long_url]).to_s.include?("invalid")
      return {
            status: :bad_request,
            error: "Enter Valid Url"
            }
    else
      return true
    end
  end
end

