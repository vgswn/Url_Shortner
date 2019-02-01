class ApplicationController < ActionController::Base
  before_action :check_session
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Call Back Function that Checks if Session is expired or not      
=end
  def check_session
    if session[:expires_at] == nil
      session[:expires_at]= Time.now
    end
    if session[:expires_at] < Time.current
      session[:authenticate]=false
    end
  end

  def check_logged_in
    if session[:authenticate] == false
      render home_page_index_path
    end
  end

  def check_logged_out
    if session[:authenticate] == true
      render home_page_index_path
    end
  end


end
