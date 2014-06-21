class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.float :estimate
      t.string :status

      t.timestamps
    end
  end
end
