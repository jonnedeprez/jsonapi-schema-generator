class Field < ApplicationRecord
  belongs_to :entity

  scope :required, -> { where required: true }

end
