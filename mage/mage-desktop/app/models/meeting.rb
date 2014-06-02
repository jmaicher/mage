class Meeting < ActiveRecord::Base
  include Roles::Activities::Context
  include Roles::Activities::Object

  scope :active, -> { where(active: true) }

  belongs_to :initiator, class_name: "Device"
  validates_presence_of :initiator

  has_many :meeting_participations
  has_many :participants, through: :meeting_participations,
    source: :meeting_participant
  has_many :participating_users, through: :meeting_participations,
    source: :meeting_participant, source_type: 'User'
  has_many :participating_devices, through: :meeting_participations,
    source: :meeting_participant, source_type: 'Device'

  has_many :poker_sessions
end # Meeting
