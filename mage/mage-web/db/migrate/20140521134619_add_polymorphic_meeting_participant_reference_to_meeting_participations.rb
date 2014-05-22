class AddPolymorphicMeetingParticipantReferenceToMeetingParticipations < ActiveRecord::Migration
  def change
    remove_column :meeting_participations, :user_id, :integer
    add_column :meeting_participations, :meeting_participant_id, :integer
    add_column :meeting_participations, :meeting_participant_type, :string 
  end
end
