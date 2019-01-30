class User < ApplicationRecord
  validates :email,uniqueness: true,presence: true
  validates :username,presence: true
  validates_length_of :password , :minimum =>6
  validates_format_of :email , :with =>/\A[A-Za-z0-9][A-za-z0-9._\-]*[\@][A-Za-z0-9][A-za-z0-9_\-]*\.[A-za-z0-9\.]+\Z/

  def self.sign_up(params)
    begin
      user = User.new
      user.username = params[:username]
      user.email = params[:email]
      user.password = UrlsHelper.md5hash(params[:password])
      user.save!
      return true
    rescue Exception => e
      return false
    end
  end

  def self.login(params)
    user = User.where(email:params[:email]).first
    if user == nil
      return nil                
    else
      if user[:password] == UrlsHelper.md5hash(params[:password]).to_s
        return true
      else
        return false
      end
    end
  end

end
