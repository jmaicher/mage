class Embedded::DeviceRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :name
  property :device_type

  link :self do
    api_device_url(represented)
  end
end
