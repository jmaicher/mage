class PokerSessionRepresenter < JSONDecorator
  property :id
  property :status

  property :backlog_item, decorator: Embedded::BacklogItemRepresenter
  collection :estimate_options, decorator: EstimateOptionDecorator

  property :current_round, if: lambda { |*| self.active? }
  property :is_current_round_complete,
    getter: lambda { |*| self.is_current_round_complete? }

  property :has_voted,
    if: lambda { |args| args[:participant] },
    getter: lambda { |args| self.has_voted?(args[:participant]) }
  property :vote,
    if: lambda { |args| args[:participant] },
    getter: lambda { |args| self.get_vote_for(args[:participant]) },
    decorator: PokerVoteRepresenter
end # PokerSessionRepresenter
