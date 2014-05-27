class AddActiveFlagToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :active, :boolean, default: true
  end
end
