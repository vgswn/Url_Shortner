module UrlsHelper
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that hashes long_url using md5   
  **End points:** Other services       
  **Host:** localhost:3000    
=end
  def self.md5hash(long_url)
    require 'digest/md5'
    short_url = Digest::MD5.hexdigest(long_url)
    return short_url
  end
=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that checks collision of short url in database   
  **End points:** Other services       
  **Host:** localhost:3000    
=end
  def self.check_collision_md5(short_url)
    for i in 0..8 do 
      check=Url.where(short_url: short_url[i,7]).first
      if check == nil
        short_url=short_url[i,7]
        return short_url
        break
      end
    end

    for i in 0..7 do 
      check=Url.where(short_url: short_url[i,8]).first
      if check == nil
        short_url=short_url[i,8]
        return short_url
        break
      end
    end

    for i in 0..6 do 
      check=Url.where(short_url: short_url[i,9]).first
      if check == nil
        short_url=short_url[i,9]
        return short_url
        break
      end
    end
  end
end
