class CreateBacklogItemAssignments < ActiveRecord::Migration
  def change
    # Note: We could have used a composite pk but rails still does not support that :-(
    create_table :backlog_item_assignments do |t|
      t.integer :backlog_id, index: true
      t.integer :backlog_item_id, index: true
      t.integer :priority

      t.timestamps
    end
  end
end
