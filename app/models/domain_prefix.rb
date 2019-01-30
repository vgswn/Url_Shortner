class DomainPrefix < ApplicationRecord
  validates :domain , presence: true,uniqueness: true
  validates :prefix,presence: true, uniqueness: true
  def self.find_prefix(domain)
    return DomainPrefix.where(domain: domain).first
  end

end