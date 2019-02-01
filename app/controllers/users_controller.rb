class UsersController < ApplicationController
  before_action :check_logged_out,only: [:login,:signup]
  def login #:nodoc:
  end

  def signup #:nodoc:
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that makes user logout   
  **End points:** Other services       
  **Host:** localhost:3000    
=end
  def logout
    session[:authenticate]=false
    flash[:success] = "Successful logged out"
    redirect_to home_page_index_path
  end

  def password_change #:nodoc:
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that Creates User in the database    
  **End points:** Other services     
  **Routes** : users_CreateUser_path     
  **Params:** 
              username,type: string ,required: yes, DESCRIPTION-> 'Name of User'  
              email,type: string ,required: yes, DESCRIPTION-> 'Email of User'  
              password,type: string ,required: yes, DESCRIPTION-> 'Password of user'  
              confirm_password,type: string ,required: yes, DESCRIPTION-> 'Confirm password token'  
  **Host:** localhost:3000    
=end
  def create_user
    if params[:username] == "" or params[:password] == "" or params[:confirm_password]=="" or params[:email]==""
      flash[:Error] = "Please Enter all Details"
      redirect_to users_signup_path
    else
      params[:username] = params[:username].strip
      params[:email] = params[:email].strip
      if params[:password] != params[:confirm_password]
        session[:errors]='error'
        flash[:error] = "Password didn't Match"
      else
        if User.sign_up(user_params) == true
          session[:authenticate]=true
          session[:expires_at] = Time.current + 20.minutes
        else
          flash[:Error] = "Please Enter Correct Details,Try Again"
          session[:errors]='error'
        end
      end
      redirect_to home_page_index_path
    end
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that Checks User in the database and Permits if password matched    
  **End points:** Other services     
  **Routes** : users_Login_path     
  **Params:** 
              email,type: string ,required: yes, DESCRIPTION-> 'Email of User'  
              password,type: string ,required: yes, DESCRIPTION-> 'Password of user'  
  **Host:** localhost:3000    
=end
  def check_login
    if params[:email] == "" or params[:password] == ""
      flash[:Error] = "Please Enter all Details"
      redirect_to users_login_path
    else
      params[:email] = params[:email].strip
      response = User.login(user_params)
      if  response == nil
        flash[:Error] = "Email is not registered Please Sign Up"
        session[:errors]='error'
      elsif response == false
        flash[:Error] = "Email or Password is wrorng"
        session[:errors]='error'
      elsif response == true
        session[:authenticate]=true
        session[:expires_at] = Time.current + 20.minutes
        flash[:success] = "Successful logged in"
      end
      redirect_to home_page_index_path
    end
  end

private
  def user_params
    params.permit(:username,:email,:password)
  end
end
