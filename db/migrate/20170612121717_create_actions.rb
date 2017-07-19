class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.string :name, null: false
      t.references :contract, foreign_key: true, null: false
      t.references :entity, foreign_key: true, null: false
      t.string :request_type, null: false, default: 'GET'

      t.timestamps
    end
  end
end
