class ActivityStream
  attr_accessor :activities

  def initialize(activities)
    @activities = activities
  end

  def self.get
    activities = Activity.all
    ActivityStream.new(activities)
  end
end # ActivityStream
