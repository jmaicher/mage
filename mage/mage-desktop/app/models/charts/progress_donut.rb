class Charts::ProgressDonut
  attr_reader :completed_until_yesterday, :completed_today, :completed_total, :amount_remaining, :amount_complete

  def initialize(sprint)
    tasks = sprint.backlog.tasks
    @amount_complete = sum_task_estimates(tasks)

    today = Date.today
    tasks_completed_until_yesterday = tasks.select { |task| task.done? && task.completed_before?(today) }
    tasks_completed_today = tasks.select { |task| task.done? && task.completed_at?(today) }

    @completed_until_yesterday = sum_task_estimates(tasks_completed_until_yesterday)
    @completed_today = sum_task_estimates(tasks_completed_today)
    @completed_total = @completed_until_yesterday + @completed_today
    @amount_remaining = @amount_complete - @completed_total
  end

  def sum_task_estimates(tasks)
    tasks.inject(0) { |total, task| total + (task.estimate.nil? ? 0 : task.estimate) }
  end

end
