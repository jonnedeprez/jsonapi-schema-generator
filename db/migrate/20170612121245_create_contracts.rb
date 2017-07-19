class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.string :client, null: false
      t.string :server, null: false
      t.string :description
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
