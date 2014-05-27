class AuthenticableRepresenter < JSONDecorator
  property :id
  property :api_token, :getter => lambda { |*| api_token.token }
end # AuthenticableRepresenter

