class RelationshipResource < BaseResource
  attributes :required, :cardinality

  has_one :entity
  has_one :dependent_entity, always_include_linkage_data: true

end