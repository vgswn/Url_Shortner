class Url < ApplicationRecord
	validates :long_url,uniqueness: true
end
