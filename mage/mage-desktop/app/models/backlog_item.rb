class BacklogItem < ActiveRecord::Base
  default_scope includes(:tags, :backlog)

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

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(str)
    self.tags = str.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

end
