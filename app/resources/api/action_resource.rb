class Api::ActionResource < Api::BaseResource
  attributes :name, :request_type

  has_one :contract
  has_one :entity

end