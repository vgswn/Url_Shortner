module DomainPrefixHelper
	def self.find_domain_prefix(domain)

		@response = DomainPrefix.check_domain(domain)
		if @response != false
			return @response
		end

		@domain_substring = domain[1,domain.size]
		@chars = @domain_substring.chars
  		@pool=(1..@domain_substring.size).flat_map { |n| @chars.combination(n).map(&:join) }
  		#puts @pool
  		@pool.each do |p|
  			@prefix = domain[0] + p
  			@response = DomainPrefix.check_prefix(@prefix)
  			if @response != true
  				return @prefix
  			end
  		end
  		return domain
	end
end
