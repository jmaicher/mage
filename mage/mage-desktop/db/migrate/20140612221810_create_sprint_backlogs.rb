class CreateSprintBacklogs < ActiveRecord::Migration
  def change
    create_table :sprint_backlogs do |t|
      t.references :sprint, index: true

      t.timestamps
    end
  end
end
