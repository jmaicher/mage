class AcceptanceCriteria < ActiveRecord::Base

  # -- Associations -------------------------------------
 
  belongs_to :backlog_item


  # -- Validations --------------------------------------

  validates_presence_of :description
  validates_length_of :description, minimum: 5, maximum: 150
end # AcceptanceCriteria
