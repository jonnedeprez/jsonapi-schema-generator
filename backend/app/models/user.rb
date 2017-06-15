class User < ApplicationRecord
  has_secure_password

  has_many :contracts
end
