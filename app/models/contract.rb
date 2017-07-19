class Contract < ApplicationRecord
  belongs_to :user
  has_many :entities
  has_many :actions
end
