class Idea < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  # -- Associations -------------------------------------

  belongs_to :author, class_name: "User"


  # -- Validations --------------------------------------

  validates_presence_of :title
  validates_length_of :title, minimum: 5, maximum: 50
end # Idea
