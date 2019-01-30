class UsersController < ApplicationController

  def login
  end

  def signup
  end

  def logout
    session[:authenticate]=false
    flash[:success] = "Successful logged out"
    redirect_to home_page_index_path
  end

  def password_change
  end

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
