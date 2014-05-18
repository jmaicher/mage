class AuthenticableRepresenter < JSONDecorator
  property :api_token, :getter => lambda { |*| api_token.token }
end # AuthenticableRepresenter

