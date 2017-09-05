class User < ApplicationRecord
  has_secure_password

  has_many :contracts

  validates :name, presence: true
  validates :username, presence: true
end
