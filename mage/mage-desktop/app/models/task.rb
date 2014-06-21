class Task < ActiveRecord::Base
  extend Enumerize

  enumerize :status, in: [:todo, :in_progress, :done], default: :todo, predicates: true

  validates_presence_of :description
  validates_length_of :description, minimum: 5, maximum: 250
  
  validates_numericality_of :estimate

  # -- Associations -------------------------------------

  has_one :assignment, class_name: "TaskAssignment"
  has_one :sprint_backlog, through: :assignment
  has_one :backlog_item, through: :assignment
end # Task
