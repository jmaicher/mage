class AuthenticableRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :api_token, :getter => lambda { |*| api_token.token }
end

