class Api::ActionResource < Api::BaseResource
  attributes :name, :request_type

  has_one :contract
  has_one :entity

  has_many :included_entities, always_include_linkage_data: true

end