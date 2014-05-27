class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.integer :meeting_type
      t.integer :initiator_id, index: true

      t.timestamps
    end
  end
end

