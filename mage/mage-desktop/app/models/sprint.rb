class Sprint < ActiveRecord::Base
  after_initialize :defaults

  validates_presence_of :goal,
    unless: :in_planning
  validates_length_of :goal, minimum: 5, maximum: 140,
    unless: :in_planning

  validates_presence_of :start_date,
    unless: :in_planning
  validates_presence_of :end_date,
    unless: :in_planning
  validate :start_date_before_end_date,
    unless: :in_planning

  has_one :backlog, class_name: "SprintBacklog", autosave: true

  def duration_in_days
    return nil if start_date.nil? or end_date.nil?
    (end_date.to_date - start_date.to_date).to_i + 1
  end

private

  def defaults
    self.build_backlog if backlog.nil?
    self.in_planning = true if in_planning.nil?
  end

  def start_date_before_end_date
    if(!start_date.nil? && !end_date.nil? &&
       start_date >= end_date)
      errors.add(:start_date, 'start date must before end date')
    end
  end

end # Sprint
