class Charts::ProgressDonutRepresenter < JSONDecorator
  property :amount_complete
  property :amount_remaining

  property :completed_until_yesterday
  property :completed_today
  property :completed_total
end # Charts::BurndownRepresenter
