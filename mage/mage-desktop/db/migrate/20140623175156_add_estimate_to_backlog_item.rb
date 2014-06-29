class AddEstimateToBacklogItem < ActiveRecord::Migration
  def change
    add_column :backlog_items, :estimate_id, :integer
  end
end
