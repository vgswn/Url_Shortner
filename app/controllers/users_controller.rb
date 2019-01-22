class UsersController < ApplicationController
  def login
  end

  def signup
  end

  def logout
  	session[:username]=nil
  	session[:authenticate]=false
    flash[:success] = "Successful logged out"

  	redirect_to home_index_path
  end

  def password_change
  end
  def create_user
    if params[:username] == "" or params[:password] == "" or params[:confirm_password]=="" or params[:email]==""
      puts "hey vipul"
      flash[:Error] = "Please Enter all Details"
      redirect_to users_signup_path
    else
    	if params[:password] != params[:confirm_password]
    			session[:errors]='error'
          flash[:Error] = "Password didn't Match"
    		redirect_to home_index_path
    	else
    	begin
    		@user = User.new
  	  	@user.username = params[:username]
  	  	@user.email = params[:email]
  	  	@user.password = UrlsHelper.md5hash(params[:password])
  	  	@user.save!
  	  	session[:username]=@user[:username]
  	  	session[:authenticate]=true
        session[:expires_at] = Time.current + 20.minutes
  	  	redirect_to home_index_path
    	rescue Exception => e
        flash[:Error] = "Please Enter Correct Details,Try Again"

    		session[:errors]='error'
    		redirect_to home_index_path
    	end
    end

  end
end
  def check_login
    if params[:email] == "" or params[:password] == ""
      puts "hey vipul"
      flash[:Error] = "Please Enter all Details"
      redirect_to users_login_path
    else
    	@user = User.where(email:params[:email]).first
      if @user == nil
        puts "here"
        flash[:Error] = "Email is not registered Please Sign Up"
        session[:errors]='error'
        redirect_to home_index_path
      
      else

        #puts UrlsHelper.md5hash(params[:password]).class
        #puts @user[:password].class
      	if @user[:password] == UrlsHelper.md5hash(params[:password]).to_s
      		session[:username]=@user[:username]
    	  	session[:authenticate]=true
          session[:expires_at] = Time.current + 20.minutes
          flash[:success] = "Successful logged in"

    	  	redirect_to home_index_path

      	else
          flash[:Error] = "Email or Password is wrorng"

      		session[:errors]='error'
      		redirect_to home_index_path

      	end
      end
    end
  end
end
