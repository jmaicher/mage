class MeetingRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :name, default: ""
  property :initiator, decorator: Embedded::DeviceRepresenter
  property :created_at, as: :started_at
  
  link :self do
    api_meeting_url(represented)
  end
end
