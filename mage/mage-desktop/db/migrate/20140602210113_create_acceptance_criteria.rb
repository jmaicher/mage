class CreateAcceptanceCriteria < ActiveRecord::Migration
  def change
    create_table :acceptance_criteria do |t|
      t.string :description
      t.boolean :done, default: false
      t.references :backlog_item, index: true

      t.timestamps
    end
  end
end
