class MeetingParticipation < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :meeting_participant, polymorphic: true
end # MeetingParticipation
