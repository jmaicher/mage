class PokerRoundResultRepresenter < JSONDecorator
  property :id, as: :poker_session_id
  property :current_round, as: :round
  collection :votes,
    getter: lambda { |*| self.get_votes },
    decorator: PokerVoteRepresenter
end # PokerRoundResultRepresenter
