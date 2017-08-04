class Entity < ApplicationRecord
  belongs_to :contract

  has_many :fields
  has_many :actions
  has_many :relationships, inverse_of: :entity, foreign_key: :entity_id
  has_many :source_relationships, class_name: 'Relationship', inverse_of: :dependent_entity, foreign_key: :dependent_entity_id

end
