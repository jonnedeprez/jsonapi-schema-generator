class Entity < ApplicationRecord
  belongs_to :contract

  has_many :fields
  has_many :actions
  has_many :relationships
  has_many :source_relationships, class_name: 'Relationship', inverse_of: 'dependent_entity'

end
