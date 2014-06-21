class AddBacklogTypeToBacklogItemAssignments < ActiveRecord::Migration
  def change
    add_column :backlog_item_assignments, :backlog_type, :string
  end
end
