class CreateTaskAssignments < ActiveRecord::Migration
  def change
    create_table :task_assignments do |t|
      t.references :backlog_item, index: true
      t.references :sprint_backlog, index: true
      t.references :task, index: true

      t.timestamps
    end
  end
end
