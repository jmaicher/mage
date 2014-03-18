class BacklogItem < ActiveRecord::Base

  validates_presence_of :title
  validates_length_of :title, minimum: 5, maximum: 50

  # backlog assignment

  has_one :backlog_assignment, class_name: "BacklogItemAssignment"
  has_one :backlog, through: :backlog_assignment

  def priority
    self.backlog_assignment.try(:priority)
  end

  # tagging
  
  has_many :taggings, class_name: "BacklogItemTagging"
  has_many :tags, through: :taggings

end
