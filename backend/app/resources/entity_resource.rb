class EntityResource < BaseResource
  attributes :name, :description

  has_one  :contract
  has_many :fields
  has_many :actions
  has_many :relationships, always_include_linkage_data: true
  has_many :source_relationships


end