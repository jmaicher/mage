class BacklogItem < ActiveRecord::Base
  include Roles::Activities::Object
  include Roles::NoteAttachable

  default_scope { includes(:backlog_assignment => :backlog) }

  # -- Associations -------------------------------------

  has_one :backlog_assignment, class_name: "BacklogItemAssignment", autosave: true

  # has_one :backlog, through: :backlog_assignment
  # This raises ActiveRecord::HasManyThroughAssociationPolymorphicSourceError: Cannot have a has_many :through association without "source_type"
  # => we use a custom getter as a workaround
  def backlog
    backlog_assignment.try(:backlog)
  end

  def backlog=(backlog)
    if backlog_assignment.nil?
      build_backlog_assignment backlog: backlog
    else
      backlog_assignment.backlog = backlog
    end
  end

  has_many :task_assignments
  has_many :tasks, through: :task_assignments

  has_many :taggings, class_name: "BacklogItemTagging"
  has_many :tags, through: :taggings

  has_many :acceptance_criteria, -> { order("created_at ASC") }, class_name: "AcceptanceCriteria"


  # -- Validations --------------------------------------

  validates_presence_of :title
  validates_length_of :title, minimum: 5, maximum: 50


  # -- Instance methods ---------------------------------

  def priority
    self.backlog_assignment.try(:priority)
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(str)
    self.tags = str.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

end # BacklogItem
