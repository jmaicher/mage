class BacklogItem < ActiveRecord::Base
  include Roles::Activities::Object

  default_scope { includes(:backlog_assignment) }

  # -- Associations -------------------------------------

  has_one :backlog_assignment, class_name: "BacklogItemAssignment"
  has_one :backlog, through: :backlog_assignment

  has_many :taggings, class_name: "BacklogItemTagging"
  has_many :tags, through: :taggings

  has_many :acceptance_criteria, class_name: "AcceptanceCriteria"


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
