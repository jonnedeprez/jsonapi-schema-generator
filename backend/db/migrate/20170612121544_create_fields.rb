class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.string :field_type, default: 'string'
      t.boolean :required
      t.references :entity, foreign_key: true, null: false

      t.timestamps
    end
  end
end
