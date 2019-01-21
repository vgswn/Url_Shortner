class Url < ApplicationRecord
	validates :long_url,uniqueness: true



	def self.check_url_present(input)
		@row=Url.new(input)
		@row.save

	end

	def self.create_new_url(input)
		@entry = Url.create(input)
	end

	def update_url(input)
			self.UPDATE(input)
	end

	def self.check_collision_md5(short_url)
		@prefix = "https://www.vg.sw.n/"
	    for i in 0..10 do
	      @check=Url.where(short_url: @prefix+short_url[i,5]).first
	      if @check == nil
	        short_url=@prefix+short_url[i,5]
	        break
	      end
	    end
	    return short_url
  	end


end
