class Meeting < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  belongs_to :initiator, class_name: "Device"
  validates_presence_of :initiator
end
