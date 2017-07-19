class Api::ContractResource < Api::BaseResource
  attributes :client, :server, :description

  has_one :user
  has_many :actions
  has_many :entities

end