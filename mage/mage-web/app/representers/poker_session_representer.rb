class PokerSessionRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :backlog_item, decorator: BacklogItemRepresenter
end
