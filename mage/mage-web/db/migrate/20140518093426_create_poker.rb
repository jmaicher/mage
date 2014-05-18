class CreatePoker < ActiveRecord::Migration
  def change
    create_table :poker do |t|
      t.references :meeting, index: true
      t.references :backlog_item, index: true

      t.timestamps
    end
  end
end
