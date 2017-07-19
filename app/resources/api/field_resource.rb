class Api::FieldResource < Api::BaseResource
  attributes :name, :field_type, :required

  has_one :entity

end