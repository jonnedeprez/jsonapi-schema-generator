class Action < ApplicationRecord
  belongs_to :contract
  belongs_to :entity

  has_and_belongs_to_many :included_entities, class_name: 'Entity', join_table: 'actions_entities'
end
