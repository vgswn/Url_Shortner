module DomainPrefixHelper
	def self.find_domain_prefix(domain)
    puts "inside helper"
		@url = "www."
		@response = DomainPrefix.check_domain(domain)
		if @response != false
			return @response
		end
		@params = Hash.new
		@params[:domain]=domain
		@domain_substring = domain[1,domain.size]
		@chars = @domain_substring.chars
  		@pool=(1..@domain_substring.size).flat_map { |n| @chars.combination(n).map(&:join) }
  		#puts @pool
  		@pool.each do |p|
  			@prefix = "www." + domain[0] + p + "co/"
  			@response = DomainPrefix.check_prefix(@prefix)
  			if @response != true
  				@params[:prefix]=@prefix
  				DomainPrefix.create_entry(@params)
  				return @prefix
  			end
  		end
  		@params[:prefix]=domain
  		DomainPrefix.create_entry(@params)
  		return domain
	end
end
