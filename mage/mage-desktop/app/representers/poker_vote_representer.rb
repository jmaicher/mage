class PokerVoteRepresenter < JSONDecorator
  property :decision, decorator: EstimateOptionDecorator
  property :user, decorator: UserRepresenter
end # PokerVoteRepresenter
