class CreateActionsToEntitiesJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :actions, :entities, id: false do |t|
      t.index :action_id
      t.index :entity_id
    end
  end
end
