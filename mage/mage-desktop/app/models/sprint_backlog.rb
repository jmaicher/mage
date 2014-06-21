class SprintBacklog < ActiveRecord::Base
  include Backlog

  belongs_to :sprint
  has_many :task_assignments
  has_many :tasks, through: :task_assignments
end # SprintBacklog
