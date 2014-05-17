class Meeting < ActiveRecord::Base
  belongs_to :initiator, class_name: "Device"
  validates_presence_of :initiator
end
