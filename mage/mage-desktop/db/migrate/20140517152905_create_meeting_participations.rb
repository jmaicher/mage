class CreateMeetingParticipations < ActiveRecord::Migration
  def change
    create_table :meeting_participations do |t|
      t.belongs_to :meeting
      t.belongs_to :user
    end
  end
end
