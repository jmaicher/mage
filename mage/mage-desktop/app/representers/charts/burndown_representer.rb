class Charts::BurndownRepresenter < JSONDecorator
  property :amount_complete
  property :number_of_days
  collection :days do
    property :day
    property :amount
  end
end # Charts::BurndownRepresenter
