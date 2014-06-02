# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.string  :key
      t.belongs_to :actor, :polymorphic => true
      # t.belongs_to :object, polymorphic => true
      # Note: We use a different key because ruby defines object_id for every object => not good!
      t.integer :activity_object_id
      t.string :object_type
      t.belongs_to :context, :polymorphic => true
      t.text    :params

      t.timestamps
    end

    add_index :activities, [:actor_id, :actor_type]
    add_index :activities, [:activity_object_id, :object_type]
    add_index :activities, [:context_id, :context_type]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
