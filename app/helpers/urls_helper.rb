module UrlsHelper
def self.base10_base64(value)
		arr= Array.new
		while value > 0 do
			remainder = value % 62
			arr << remainder
			value = value / 62
		end
		return arr.reverse
	end
	def self.base64_base10(value)
		id=0
		value.each do |num|
			id=id*62+num
		end
		return id
	end
	def self.generate_hash(hash_value)
		@short_url = ""
        hash_value.each do |index|
          if index <= 25
            @short_url += (index + 97).chr
          elsif index <=51
            @short_url +=  (index + 39).chr
          else
            @short_url +=  (index - 4).chr

          end
        end
        puts @short_url
        @short_url_prefix=""
        5.times do
          @short_url_prefix+=(48+rand(75)).chr
        end
        puts @short_url_prefix
        @short_url= @short_url_prefix+@short_url
        return @short_url
	end

	def self.md5hash(long_url)
		require 'digest/md5'
		short_url = Digest::MD5.hexdigest(long_url)
		return short_url

	end
	
	def self.check_collision_md5(short_url)

	    for i in 0..10 do 

	      @check=Url.where(short_url: short_url[i,5]).first
	      if @check == nil
	        short_url=short_url[i,5]
	        break
	      
	      end
	    
	    end

	    return short_url
  
  	end

  	
end

