class ApplicationController < ActionController::Base
  before_action :check_session

=begin
  **Author:** Vipul Kumar     
  **Common Name:** Call Back Function that Checks if Session is expired or not      
=end
  def check_session
    if session[:expires_at] != nil
      if session[:expires_at] < Time.current
        session[:username]=nil
        session[:authenticate]=false
        session[:expires_at]=nil
        render home_page_index_path
      end
    end
  end
end
