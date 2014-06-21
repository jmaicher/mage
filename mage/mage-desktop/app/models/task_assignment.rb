class TaskAssignment < ActiveRecord::Base
  belongs_to :task
  validates_uniqueness_of :task_id

  belongs_to :backlog_item
  belongs_to :sprint_backlog
end # TaskAssignment
