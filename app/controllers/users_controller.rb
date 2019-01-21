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
      session[:expires_at] = Time.current + 2.minutes
	  	redirect_to home_index_path
  	rescue Exception => e
      flash[:Error] = "Email is taken"

  		session[:errors]='error'
  		redirect_to home_index_path
  	end

  end
end
  def check_login
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
      session[:expires_at] = Time.current + 2.minutes
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
