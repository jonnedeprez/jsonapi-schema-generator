class Relationship < ApplicationRecord

  belongs_to :entity
  belongs_to :dependent_entity, class_name: 'Entity', foreign_key: 'dependent_entity_id', inverse_of: :source_relationships

  scope :required, -> { where required: true }

  def hyphenized_name
    relationship_name = dependent_entity.name
    if is_plural?
      relationship_name = relationship_name.pluralize
    end

    relationship_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def is_plural?
    cardinality === 'HAS_MANY'
  end

end
