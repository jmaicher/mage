class ActivityStream
  attr_accessor :activities

  def initialize(activities)
    @activities = activities
  end

  def self.get
    activities = Activity.order("created_at DESC").where(context_id: nil)
    ActivityStream.new(activities)
  end

  def self.get_for_context(context)
    activities = context.activities_as_context.order("created_at DESC")
    ActivityStream.new(activities)
  end

end # ActivityStream
