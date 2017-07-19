class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.references :entity, foreign_key: true, null: false
      t.references :dependent_entity, null: false, references: :entities
      t.string :cardinality, null: false, default: 'BELONGS_TO'
      t.boolean :required, null: false, default: false
      t.timestamps
    end
  end
end
