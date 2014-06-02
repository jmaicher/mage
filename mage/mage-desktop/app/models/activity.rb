class Activity < ActiveRecord::Base
  default_scope { includes(:actor, :object, :context) }

  belongs_to :actor, polymorphic: true
  # Note: We use different keys because ruby defines object_id for every object
  belongs_to :object, polymorphic: true,
    foreign_key: "activity_object_id"
  belongs_to :context, polymorphic: true

  serialize :params, Hash

  validates_presence_of :actor
  validates_presence_of :key
end
