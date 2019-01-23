class DomainPrefix < ApplicationRecord

  def self.check_domain(domain)
    @row = DomainPrefix.where(domain:domain).first
    if @row
      return @row[:prefix]
    end
    return false
  end

  def self.check_prefix(prefix)
    @row = DomainPrefix.where(prefix:prefix).first
    if @row
      return true
    end
    return false
  end

  def self.create_entry(params)
    DomainPrefix.create(params)
  end
  
end