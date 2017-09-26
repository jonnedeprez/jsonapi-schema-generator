class Api::RelationshipResource < Api::BaseResource
  attributes :required, :cardinality, :name

  has_one :entity, foreign_key: 'entity_id', always_include_linkage_data: true
  has_one :dependent_entity, foreign_key: 'dependent_entity_id', always_include_linkage_data: true

end