class Meeting < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  belongs_to :initiator, class_name: "Device"
  validates_presence_of :initiator

  has_many :meeting_participations
  has_many :participants, through: :meeting_participations, source: :user

  has_many :poker_sessions
end # Meeting
