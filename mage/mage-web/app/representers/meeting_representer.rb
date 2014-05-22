class MeetingRepresenter < JSONDecorator
  property :id
  property :name, default: ""
  property :initiator, decorator: Embedded::DeviceRepresenter
  property :created_at, as: :started_at

  property :is_participating,
    if: lambda { |args| args[:participant] },
    getter: lambda { |args| args[:participant].participates_in?(self) }
  
  link :self do
    api_meeting_url(represented)
  end
end # MeetingRepresenter
