class User < ApplicationRecord
validates :email,uniqueness: true
validates_length_of :password , :minimum =>6
validates_format_of :email , :with =>/\A[A-Za-z0-9][A-za-z0-9._\-]*[\@][A-Za-z0-9][A-za-z0-9_\-]*\.[A-za-z0-9]+\Z/

end
