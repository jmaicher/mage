class Embedded::DeviceRepresenter < JSONDecorator
  property :id
  property :name
  property :device_type

  link :self do
    api_device_url(represented)
  end
end # Embedded::DeviceRepresenter
