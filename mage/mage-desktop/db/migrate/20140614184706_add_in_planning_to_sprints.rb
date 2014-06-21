class AddInPlanningToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :in_planning, :boolean
  end
end
