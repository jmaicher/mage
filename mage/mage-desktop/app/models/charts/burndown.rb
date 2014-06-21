# I'm writing class while watching ENG-URU, WM 2014..
# ...so I'm sorry if it doesn't make any sense at all :-)

class Charts::ProgressChart
  attr_reader :days, :amount_complete, :number_of_days

  def initialize(sprint)
    @days = []
    @number_of_days = sprint.duration_in_days
    @amount_complete = sprint.backlog.tasks.inject(0) { |total, task| total + task.estimate }

    compute(sprint)
  end

  def compute(sprint)
    # Override
  end
end # Charts::ProgressChart

Charts::ProgressChart::Day = Struct.new(:day, :amount)

class Charts::Burndown < Charts::ProgressChart

  def compute(sprint)
    add_remaining_for_day(0, @amount_complete) 

    amount_remaining = @amount_complete

    today = Time.now.to_date
    days_from_sprint_start = (today - sprint.start_date.to_date).to_i

    (1..[@number_of_days, days_from_sprint_start].min).each do |i|
      date = sprint.start_date + (i - 1).days
      tasks_completed = sprint.backlog.tasks.select { |task| task.completed_at.try(:to_date).eql?(date.to_date) }
      amount_completed = tasks_completed.inject(0) { |total, task| total + (task.estimate.nil? ? 0 : task.estimate) }
      amount_remaining -= amount_completed
      add_remaining_for_day(i, amount_remaining)
    end
  end

private

  def add_remaining_for_day(day, remaining)
    @days.push(Charts::ProgressChart::Day.new(day, remaining))
  end

end # Charts::Burndown
