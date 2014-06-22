require 'active_support/concern'

module Roles::MeetingParticipant
  extend ActiveSupport::Concern
  
  included do
    has_many :meeting_participations, as: :meeting_participant
    has_many :meetings, through: :meeting_participations 
  end

  def participates_in?(meeting)
    self.meetings.where(id: meeting.id).exists?
  end

  def participate!(meeting)
    self.meetings << meeting
  end

end # Roles::MeetingParticipant
