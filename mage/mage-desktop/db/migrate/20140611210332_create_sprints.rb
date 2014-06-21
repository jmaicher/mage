class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :goal
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
