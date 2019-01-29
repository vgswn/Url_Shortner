class DomainPrefix < ApplicationRecord

  def self.find_prefix(domain)
    return DomainPrefix.where(domain: domain).first
  end

end