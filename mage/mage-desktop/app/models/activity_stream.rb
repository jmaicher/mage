class ActivityStream
  attr_accessor :activities

  def initialize(activities)
    @activities = activities
  end

  def self.get
    activities = Activity.order("created_at DESC")
    ActivityStream.new(activities)
  end
end # ActivityStream
