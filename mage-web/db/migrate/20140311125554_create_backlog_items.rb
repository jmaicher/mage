class CreateBacklogItems < ActiveRecord::Migration
  def change
    create_table :backlog_items do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
