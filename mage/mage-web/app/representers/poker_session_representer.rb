class PokerSessionRepresenter < JSONDecorator
  property :id
  property :backlog_item, decorator: Embedded::BacklogItemRepresenter
end # PokerSessionRepresenter
