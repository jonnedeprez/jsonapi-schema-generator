class CreateEntities < ActiveRecord::Migration[5.1]
  def change
    create_table :entities do |t|
      t.string :name, null: false
      t.string :description
      t.references :contract, foreign_key: true, null: false

      t.timestamps
    end
  end
end
