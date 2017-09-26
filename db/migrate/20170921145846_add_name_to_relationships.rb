class AddNameToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_column :relationships, :name, :string
  end
end
